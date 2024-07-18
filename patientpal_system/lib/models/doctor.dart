import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  final String id;
  final String name;
  final String department;
  final Map<String, String> workHours;
  final List<String> workDays;

  Doctor({
    required this.id,
    required this.name,
    required this.department,
    required this.workHours,
    required this.workDays,
  });

  factory Doctor.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Doctor(
      id: doc.id,
      name: data['name'] ?? '',
      department: data['department'] ?? '',
      workHours: Map<String, String>.from(data['work_hours'] ?? {}),
      workDays: List<String>.from(data['work_days'] ?? []),
    );
  }
}
