import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AmbulanceTrackingScreen extends StatefulWidget {
  @override
  _AmbulanceTrackingScreenState createState() => _AmbulanceTrackingScreenState();
}

class _AmbulanceTrackingScreenState extends State<AmbulanceTrackingScreen> {
  late GoogleMapController _controller;
  bool _isMapLoading = true;

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    setState(() {
      _isMapLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ambulance Tracking'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(0.3476, 32.5825),
              zoom: 12.0,
            ),
            markers: {
              Marker(
                markerId: MarkerId('ambulance'),
                position: LatLng(0.3476, 32.5825),
                infoWindow: InfoWindow(title: 'Ambulance'),
              ),
            },
            onMapCreated: _onMapCreated,
          ),
          if (_isMapLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
