import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DoctorProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerDoctor(String name, String department, Map<String, String> workHours, List<String> workDays) async {
    await _firestore.collection('doctors').add({
      'name': name,
      'department': department,
      'work_hours': workHours,
      'work_days': workDays,
    });
  }
}
