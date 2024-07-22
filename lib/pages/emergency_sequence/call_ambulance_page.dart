import 'package:flutter/material.dart';
import 'getting_ambulance_page.dart';

class CallAmbulancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Call Ambulance'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Getting the nearest ambulance for you...'),
            SizedBox(height: 16),
            CircularProgressIndicator(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GettingAmbulancePage()),
                );
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}    