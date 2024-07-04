import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/prescription_provider.dart';
import 'prescriptions_detail_screen.dart';

class PrescriptionsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prescriptionProvider = Provider.of<PrescriptionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Prescriptions'),
      ),
      body: ListView.builder(
        itemCount: prescriptionProvider.prescriptions.length,
        itemBuilder: (context, index) {
          final prescription = prescriptionProvider.prescriptions[index];
          return ListTile(
            title: Text('Prescription ${index + 1}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrescriptionDetailScreen(prescription: prescription),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
