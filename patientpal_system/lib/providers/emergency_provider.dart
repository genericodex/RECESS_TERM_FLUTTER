import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EmergencyProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendEmergencyRequest(String patientId, double latitude, double longitude) async {
    await _firestore.collection('emergency_requests').add({
      'patient_id': patientId,
      'location': {'latitude': latitude, 'longitude': longitude},
      'status': 'pending',
    });
  }
}
