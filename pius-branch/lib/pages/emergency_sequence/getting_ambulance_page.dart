import 'package:flutter/material.dart';
import 'ambulance_on_the_way_page.dart';

class GettingAmbulancePage extends StatelessWidget {
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
            Text('Reach time: 10 Mins'),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AmbulanceOnTheWayPage()),
                );
              },
              child: Text('Confirm Ambulance'),
            ),
          ],
        ),
      ),
    );
  }
}
