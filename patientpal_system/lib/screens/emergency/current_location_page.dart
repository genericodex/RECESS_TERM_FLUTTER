import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart' as lottie;
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  maps.GoogleMapController? _mapController;
  LocationData? _currentLocation;
  List<maps.Marker> _ambulanceMarkers = [];
  List<maps.LatLng> _routeCoordinates = [];
  final Location _location = Location();
  maps.LatLng? _lastCameraPosition;
  bool _userMovedMap = false;
  static const double _radius = 50.0; // Define the geofence radius (in km)
  bool _isLoading = true;
  bool _isSearching = true; // New state variable for searching
  String _distanceText = "";
  String _durationText = "";
  String _ambulanceName = ""; // New state variable for ambulance name
  QueryDocumentSnapshot? _nearestAmbulance; // Store nearest ambulance details

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentLocation = await _location.getLocation();
    _location.onLocationChanged.listen((LocationData locationData) {
      if (_mapController != null && !_userMovedMap) {
        if (_lastCameraPosition == null ||
            _distanceBetween(_lastCameraPosition!, maps.LatLng(locationData.latitude!, locationData.longitude!)) > 0.01) {
          _mapController!.animateCamera(maps.CameraUpdate.newCameraPosition(
            maps.CameraPosition(
              target: maps.LatLng(locationData.latitude!, locationData.longitude!),
              zoom: 14.0,
            ),
          ));
          _lastCameraPosition = maps.LatLng(locationData.latitude!, locationData.longitude!);
        }
      }
      setState(() {
        _currentLocation = locationData;
      });
      _getNearbyAmbulances();
    });
  }

  void _onMapCreated(maps.GoogleMapController controller) {
    _mapController = controller;

    if (_currentLocation != null) {
      _mapController!.animateCamera(maps.CameraUpdate.newCameraPosition(
        maps.CameraPosition(
          target: maps.LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
          zoom: 14.0,
        ),
      ));
      _getNearbyAmbulances();
    }
  }

  Future<void> _getNearbyAmbulances() async {
    if (_currentLocation == null) return;
    final double currentLat = _currentLocation!.latitude!;
    final double currentLng = _currentLocation!.longitude!;

    // Fetch ambulance data from Firestore
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('ambulances').get();
    List<QueryDocumentSnapshot> docs = snapshot.docs;

    double minDistance = double.infinity;

    List<maps.Marker> markers = [];

    for (var doc in docs) {
      double ambulanceLat = doc['latitude'];
      double ambulanceLng = doc['longitude'];
      double distance = _distanceBetween(
          maps.LatLng(currentLat, currentLng), maps.LatLng(ambulanceLat, ambulanceLng));

      if (distance <= _radius) {
        markers.add(
          maps.Marker(
            markerId: maps.MarkerId(doc.id),
            position: maps.LatLng(ambulanceLat, ambulanceLng),
            icon: maps.BitmapDescriptor.defaultMarkerWithHue(maps.BitmapDescriptor.hueRed),
            infoWindow: maps.InfoWindow(title: doc['name']),
          ),
        );

        if (distance < minDistance) {
          minDistance = distance;
          _nearestAmbulance = doc;
        }
      }
    }

    setState(() {
      _ambulanceMarkers = markers;
      _isLoading = false;
      _isSearching = false; // Update state when search is complete
      if (_nearestAmbulance != null) {
        _ambulanceName = _nearestAmbulance!['name'];
      }
    });

    if (_nearestAmbulance != null) {
      _getRoute(_nearestAmbulance!['latitude'], _nearestAmbulance!['longitude']);
    }
  }

  Future<void> _getRoute(double destLat, double destLng) async {
    if (_currentLocation == null) return;
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_currentLocation!.latitude},${_currentLocation!.longitude}&destination=$destLat,$destLng&key=AIzaSyBR9qNMzq5xCTTRaVum310cfG8_vQALnus';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data); // Debug: print the entire response data

      if (data['routes'].isNotEmpty) {
        final List<maps.LatLng> points = _decodePolyline(data['routes'][0]['overview_polyline']['points']);
        final distance = data['routes'][0]['legs'][0]['distance']['text'];
        final duration = data['routes'][0]['legs'][0]['duration']['text'];
        setState(() {
          _routeCoordinates = points;
          _distanceText = distance;
          _durationText = duration;
        });
      } else {
        print('No routes found');
      }
    } else {
      print('Failed to fetch route');
    }
  }

  List<maps.LatLng> _decodePolyline(String polyline) {
    List<maps.LatLng> coordinates = [];
    int index = 0, len = polyline.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;

      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      coordinates.add(maps.LatLng(lat / 1E5, lng / 1E5));
    }

    return coordinates;
  }

  double _distanceBetween(maps.LatLng start, maps.LatLng end) {
    const double p = 0.017453292519943295; // Math.PI / 180
    final double a = 0.5 - cos((end.latitude - start.latitude) * p) / 2 +
        cos(start.latitude * p) * cos(end.latitude * p) *
            (1 - cos((end.longitude - start.longitude) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Location',
          style: GoogleFonts.anuphan(textStyle: TextStyle(color: Colors.white, letterSpacing: .5)),
        ),
        backgroundColor: Color.fromARGB(255, 171, 38, 19),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: <Widget>[
          _currentLocation == null || _isLoading
              ? Center(child: CircularProgressIndicator())
              : maps.GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: maps.CameraPosition(
              target: maps.LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
              zoom: 14.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: Set.from(_ambulanceMarkers),
            polylines: {
              maps.Polyline(
                polylineId: maps.PolylineId('route'),
                points: _routeCoordinates,
                color: Colors.blue,
                width: 5,
              ),
            },
            onCameraMove: (_) {
              _userMovedMap = true;
            },
            onCameraIdle: () {
              _userMovedMap = false;
            },
          ),
          if (_isSearching)
            Container(
              color: Colors.white.withOpacity(0.8),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text(
                      'Searching for nearby ambulances...',
                      style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.black, letterSpacing: .5)),
                    ),
                  ],
                ),
              ),
            ),
          if (!_isSearching && _nearestAmbulance != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                    child: lottie.Lottie.asset(
                      'assets/images/Animation - 1721588845402.json',
                      width: 100,
                      height: 100,
                    ),
                  ),
                    Text(
                      'Nearest Ambulance: $_ambulanceName',
                      style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.black, letterSpacing: .5, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Estimated Time of Arrival: $_durationText',
                      style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.black, letterSpacing: .5)),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Distance: $_distanceText',
                      style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.black, letterSpacing: .5)),
                    ),
                    Row(
                    children: [
                      Icon(Icons.phone, color: Color.fromARGB(255, 171, 38, 19)),
                      SizedBox(width: 5),
                      Text('+256 780 204837', style: TextStyle(color: Colors.black)),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          final Uri url = Uri(
                            scheme: 'tel',
                            path: "+256 780 204837",
                          );
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            print('cannot launch url');
                          }
                        },
                        child: Text('CALL AMBULANCE',
                            style: GoogleFonts.anuphan(
                              color: Colors.white,
                            )),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 171, 38, 19),
                        ),
                      ),
                    ],
                  ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
