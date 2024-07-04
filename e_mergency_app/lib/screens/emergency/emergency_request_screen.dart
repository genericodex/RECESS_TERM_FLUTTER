import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/emergency_provider.dart';

class EmergencyRequestScreen extends StatelessWidget {
  const EmergencyRequestScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final emergencyProvider = Provider.of<EmergencyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Request'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Emergency Request'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  emergencyProvider.sendEmergencyRequest();
                },
                child: const Text('Send Emergency Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
