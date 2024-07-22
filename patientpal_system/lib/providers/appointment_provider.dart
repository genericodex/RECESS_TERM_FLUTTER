import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> getAvailableTimeSlots(DateTime date) async {
    List<String> timeSlots = [];
    QuerySnapshot querySnapshot = await _firestore.collection('time_slots')
        .where('date', isEqualTo: date.toIso8601String().split('T')[0])
        .get();

    for (var doc in querySnapshot.docs) {
      timeSlots.add(doc['time']);
    }

    return timeSlots;
  }

  Future<void> createAppointment(
    String userId,
    String ailmentType,
    DateTime dateTime,
  ) async {
    try {
      // Fetch available doctor
      var doctor = await _getAvailableDoctor(ailmentType, dateTime);

      if (doctor == null) {
        throw Exception('No available doctors for the selected date and time');
      }

      await _firestore.collection('appointments').add({
        'patient_id': userId,
        'doctor_id': doctor['uid'],
        'Doctor': doctor['name'],
        'ailment_type': ailmentType,
        'date_time': dateTime,
        'status': 'Booked',
      });
    } catch (e) {
      throw Exception('Failed to create appointment: $e');
    }
  }

  Future<Map<String, dynamic>?> _getAvailableDoctor(String ailmentType, DateTime dateTime) async {
    QuerySnapshot querySnapshot = await _firestore.collection('doctors')
        .where('department', isEqualTo: ailmentType)
        .get();

    String selectedDay = DateFormat('EEEE').format(dateTime); // e.g., 'Monday'
    String selectedTime = DateFormat.Hm().format(dateTime); // e.g., '10:00'

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> doctor = doc.data() as Map<String, dynamic>;

      // Convert the array structure of working_days to a list
      List<String> workingDays = List<String>.from(doctor['work_days']);

      Map<String, String> workingHours = Map<String, String>.from(doctor['work_hours']);

      if (workingDays.contains(selectedDay) &&
          _isWithinWorkingHours(selectedTime, workingHours['start']!, workingHours['end']!)) {
        return doctor;
      }
    }

    return null;
  }

  bool _isWithinWorkingHours(String selectedTime, String start, String end) {
    TimeOfDay selected = _parseTime(selectedTime);
    TimeOfDay startTime = _parseTime(start);
    TimeOfDay endTime = _parseTime(end);

    return (selected.hour > startTime.hour || (selected.hour == startTime.hour && selected.minute >= startTime.minute)) &&
           (selected.hour < endTime.hour || (selected.hour == endTime.hour && selected.minute <= endTime.minute));
  }

  TimeOfDay _parseTime(String time) {
    final format = DateFormat.Hm(); // 'HH:mm'
    return TimeOfDay.fromDateTime(format.parse(time));
  }
}
