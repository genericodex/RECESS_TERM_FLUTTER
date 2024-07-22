import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:patientpal_system/providers/emergency_provider.dart';
import 'package:patientpal_system/providers/auth_provider.dart';

class EmergencyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Emergency SOS'),leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
            final authProvider = context.read<AuthProvider>();
            await context.read<EmergencyProvider>().sendEmergencyRequest(authProvider.user!.uid, position.latitude, position.longitude);
          },
          child: Text('Send SOS'),
        ),
      ),
    );
  }
}
