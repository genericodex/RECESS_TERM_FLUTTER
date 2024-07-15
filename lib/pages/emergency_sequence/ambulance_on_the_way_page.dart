import 'package:flutter/material.dart';

class AmbulanceOnTheWayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Getting Ambulance'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Government College Ambulance'),
            SizedBox(height: 8),
            Text('On the way'),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Add your call driver logic here
              },
              child: Text('Call Driver'),
            ),
          ],
        ),
      ),
    );
  }
}
