import 'package:flutter/material.dart';
import '../../models/prescription.dart';

class PrescriptionDetailScreen extends StatelessWidget {
  final Prescription prescription;

  PrescriptionDetailScreen({required this.prescription});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prescription Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Doctor: ${prescription.doctor}', style: TextStyle(fontSize: 18)),
            Text('Date: ${prescription.date}', style: TextStyle(fontSize: 18)),
            Text('Medicines: ${prescription.medicines}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
