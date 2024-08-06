import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:patientpal_system/providers/appointment_provider.dart';

class DoctorProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerDoctor(String uid, String name, String department, Map<String, String> workHours, List<String> workDays) async {
    // ignore: unused_local_variable
    DocumentReference docRef = await _firestore.collection('doctors').add({
      'name': name,
      // 'uid': uid,
      'department': department,
      'work_hours': workHours,
      'work_days': workDays,
    });

    // Generate time slots for the newly registered doctor
    await generateTimeSlots();
  }
}
