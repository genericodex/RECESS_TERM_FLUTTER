import 'package:flutter/material.dart';
import '../models/appointment.dart';
import 'package:uuid/uuid.dart';

class AppointmentProvider with ChangeNotifier {
  List<Appointment> _appointments = [];
  String _doctor = '';
  String _date = '';
  String _time = '';

  List<Appointment> get appointments => _appointments;

  String get doctor => _doctor;
  set doctor(String value) {
    _doctor = value;
    notifyListeners();
  }

  String get date => _date;
  set date(String value) {
    _date = value;
    notifyListeners();
  }

  String get time => _time;
  set time(String value) {
    _time = value;
    notifyListeners();
  }

  void bookAppointment() {
    final appointment = Appointment(
      id: Uuid().v4(),
      doctor: _doctor,
      date: _date,
      time: _time,
    );
    _appointments.add(appointment);
    notifyListeners();
  }
}
