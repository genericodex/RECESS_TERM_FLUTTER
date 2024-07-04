import 'package:flutter/material.dart';
import '../models/appointment.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;

  AppointmentCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(appointment.doctor),
        subtitle: Text('${appointment.date} at ${appointment.time}'),
      ),
    );
  }
}
