import 'package:flutter/material.dart';
import '../models/prescription.dart';

class PrescriptionCard extends StatelessWidget {
  final Prescription prescription;

  PrescriptionCard({required this.prescription});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(prescription.doctor),
        subtitle: Text('${prescription.date} - ${prescription.medicines}'),
      ),
    );
  }
}
