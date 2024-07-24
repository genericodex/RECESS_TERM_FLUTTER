import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

class AppointmentProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createAppointment(String patientId, String ailmentType, DateTime dateTime) async {
    DateTime appointmentDateTime = dateTime;
    String appointmentDay = _getDayOfWeekString(appointmentDateTime.weekday); // Use a function to get day as a string
    TimeOfDay appointmentTime = TimeOfDay.fromDateTime(appointmentDateTime);

    print('Searching for doctors in department: $ailmentType');
    print('Appointment date and time: ${appointmentDateTime.toLocal()}');
    print('Appointment day: $appointmentDay');

    QuerySnapshot doctorsSnapshot = await _firestore.collection('doctors')
        .where('department', isEqualTo: ailmentType)
        .get();

    if (doctorsSnapshot.docs.isEmpty) {
      throw Exception('No doctors found in the specified department');
    }

    for (var doc in doctorsSnapshot.docs) {
      Map<String, dynamic>? doctorData = doc.data() as Map<String, dynamic>?;

      if (doctorData == null) {
        continue;
      }

      print('Checking doctor: ${doctorData['name']}');
      List<dynamic>? workDaysList = doctorData['work_days'];
      List<String> workDays = workDaysList != null ? List<String>.from(workDaysList) : [];

      Map<String, dynamic>? workHoursMap = doctorData['work_hours'];
      Map<String, String> workHours = workHoursMap != null ? Map<String, String>.from(workHoursMap) : {};

      print('Doctor work days: $workDays');
      print('Doctor work hours: $workHours');

      if (workDays.contains(appointmentDay)) {
        String? startHourStr = workHours['start'];
        String? endHourStr = workHours['end'];

        if (startHourStr != null && endHourStr != null) {
          TimeOfDay startTime = _parseTime(startHourStr);
          TimeOfDay endTime = _parseTime(endHourStr);

          print('Doctor start time: ${_formatTimeOfDay(startTime)}');
          print('Doctor end time: ${_formatTimeOfDay(endTime)}');

          if (_isTimeWithinRange(appointmentTime, startTime, endTime)) {
            print('Found matching doctor: ${doctorData['name']}');

            await _firestore.collection('appointments').add({
              'patient_id': patientId,
              'doctor_id': doc.id,
              'ailment_type': ailmentType,
              'date_time': Timestamp.fromDate(appointmentDateTime),
              'status': 'Scheduled',
            });

            await _firestore.collection('notifications').add({
              'doctor_id': doc.id,
              'message': 'You have a new appointment',
              'date_time': Timestamp.now(),
            });

            notifyListeners(); // Notify listeners that the appointment was created
            return;
          } else {
            print('Appointment time not within doctor\'s working hours.');
          }
        } else {
          print('Doctor work hours are not properly set.');
        }
      } else {
        print('Doctor does not work on this day.');
      }
    }

    throw Exception('No matching doctor available for the selected date and time');
  }

  TimeOfDay _parseTime(String time) {
  final parts = time.split(':');
  int hour = int.parse(parts[0]);
  final int minute = int.parse(parts[1]);
  return TimeOfDay(hour: hour, minute: minute);
}

  bool _isTimeWithinRange(TimeOfDay time, TimeOfDay start, TimeOfDay end) {
    final current = Duration(hours: time.hour, minutes: time.minute);
    final startDuration = Duration(hours: start.hour, minutes: start.minute);
    final endDuration = Duration(hours: end.hour, minutes: end.minute);
    return current >= startDuration && current <= endDuration;
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  String _getDayOfWeekString(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }
}
