import 'package:flutter/material.dart';
import '../../models/appointment.dart';

class AppointmentDetailScreen extends StatelessWidget {
  final Appointment appointment;

  AppointmentDetailScreen({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Doctor: ${appointment.doctor}', style: TextStyle(fontSize: 18)),
            Text('Date: ${appointment.date}', style: TextStyle(fontSize: 18)),
            Text('Time: ${appointment.time}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}