import 'package:e_mergency_app/screens/emergency/ambulance_tracking_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/emergency_provider.dart';

class EmergencyHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final emergencyProvider = Provider.of<EmergencyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency History'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: emergencyProvider.history.length,
              itemBuilder: (context, index) {
                final request = emergencyProvider.history[index];
                return ListTile(
                  title: Text('Request ${index + 1}'),
                  subtitle: Text('Status: ${request.status}'),
                  onTap: () {
                    Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AmbulanceTrackingScreen()),
                );
                  },
                );
                
              },
            ),
          ),
          ElevatedButton(
                onPressed: () {
                  emergencyProvider.sendEmergencyRequest();
                },
                child: const Text('Send Emergency Request'),
              ),
        ],
      ),
    );
  }
}
