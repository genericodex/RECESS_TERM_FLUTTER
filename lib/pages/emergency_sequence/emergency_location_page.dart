import 'package:flutter/material.dart';
import 'current_location_page.dart';

class EmergencyLocationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Your Location'),
            SizedBox(height: 8),
            Text('AVS Layout, Koramangala, Bengaluru, Karnataka 560034'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CurrentLocationPage()),
                );
              },
              child: Text('Change Location'),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CurrentLocationPage()),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Call Ambulance'),
            ),
          ],
        ),
      ),
    );
  }
}
