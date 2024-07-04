import 'package:flutter/material.dart';
import '../models/prescription.dart';
import 'package:uuid/uuid.dart';

class PrescriptionProvider with ChangeNotifier {
  List<Prescription> _prescriptions = [];

  List<Prescription> get prescriptions => _prescriptions;

  void addPrescription(String doctor, String date, String medicines) {
    final prescription = Prescription(
      id: Uuid().v4(),
      doctor: doctor,
      date: date,
      medicines: medicines,
    );
    _prescriptions.add(prescription);
    notifyListeners();
  }
}
