import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/appointment_provider.dart';

class AppointmentBookingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appointmentProvider = Provider.of<AppointmentProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Doctor'),
              onChanged: (value) => appointmentProvider.doctor = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Date'),
              onChanged: (value) => appointmentProvider.date = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Time'),
              onChanged: (value) => appointmentProvider.time = value,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                appointmentProvider.bookAppointment();
                Navigator.pop(context);
              },
              child: Text('Book Appointment'),
            ),
          ],
        ),
      ),
    );
  }
}
