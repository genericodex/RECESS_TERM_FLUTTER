import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart' as lottie;
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  maps.GoogleMapController? _mapController;
  LocationData? _currentLocation;
  maps.LatLng _ambulanceLocation = maps.LatLng(0.327771, 32.570843); // Example ambulance location
  List<maps.LatLng> _routeCoordinates = [];

  final Location _location = Location();
  maps.LatLng? _lastCameraPosition;
  bool _userMovedMap = false;

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
        if (_lastCameraPosition == null || _distanceBetween(_lastCameraPosition!, maps.LatLng(locationData.latitude!, locationData.longitude!)) > 0.01) {
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
      _getRoute();
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
      _getRoute();
    }
  }

  Future<void> _getRoute() async {
    if (_currentLocation == null) return;
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_currentLocation!.latitude},${_currentLocation!.longitude}&destination=${_ambulanceLocation.latitude},${_ambulanceLocation.longitude}&key=AIzaSyDp_mN2CoC8yrUrURxsGMP7qA0zKclTwzI';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<maps.LatLng> points = _decodePolyline(data['routes'][0]['overview_polyline']['points']);
      setState(() {
        _routeCoordinates = points;
      });
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
          _currentLocation == null
              ? Center(child: CircularProgressIndicator())
              : maps.GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: maps.CameraPosition(
                    target: maps.LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
                    zoom: 14.0,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  markers: {
                    maps.Marker(
                      markerId: maps.MarkerId('ambulanceLocation'),
                      position: _ambulanceLocation,
                    ),
                  },
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
          Positioned(
            bottom: 20.0,
            left: 20.0,
            right: 20.0,
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: lottie.Lottie.asset(
                      'assets/images/Animation - 1721588845402.json',
                      width: 100,
                      height: 100,
                    ),
                  ),
                  SizedBox(height: 10),
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
