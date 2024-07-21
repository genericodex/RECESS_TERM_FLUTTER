import 'package:flutter/material.dart';
import 'call_ambulance_page.dart';

class CurrentLocationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Current Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Drop the pin at the exact location'),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CallAmbulancePage()),
                );
              },
              child: Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
