import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> getAvailableTimeSlots(DateTime date, String ailmentType) async {
    List<String> timeSlots = [];
    QuerySnapshot querySnapshot = await _firestore.collection('time_slots')
        .where('date', isEqualTo: date.toIso8601String().split('T')[0])
        .where('ailment_type', isEqualTo: ailmentType)
        .get();

    for (var doc in querySnapshot.docs) {
      timeSlots.add(doc['time']);
    }

    return timeSlots;
  }

void addTimeSlots() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<String> timeSlots = [
    "09:00",
    "10:00",
    "11:00",
    "12:00",
    "13:00",
    "14:00",
    "15:00"
  ];

  
  List<String> ailmentTypes = ["Dental", "Optics", "General", "ENT"];
  DateTime startDate = DateTime(2024, 7, 24);
  int daysToAdd = 7;

  for (int i = 0; i < daysToAdd; i++) {
    DateTime date = startDate.add(Duration(days: i));
    for (String ailmentType in ailmentTypes) {
      for (String time in timeSlots) {
        await firestore.collection('time_slots').add({
          "date": date.toIso8601String().split('T')[0],
          "ailment_type": ailmentType,
          "time": time,
          "doctor_id": "doctor123", // Replace with actual doctor ID
          "available": true
        });
      }
    }
  }
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

    // Mark the selected time slot as unavailable
    QuerySnapshot querySnapshot = await _firestore.collection('time_slots')
      .where('date', isEqualTo: dateTime.toIso8601String().split('T')[0])
      .where('ailment_type', isEqualTo: ailmentType)
      .where('time', isEqualTo: DateFormat.Hm().format(dateTime))
      .get();

    if (querySnapshot.docs.isNotEmpty) {
      var timeSlotDoc = querySnapshot.docs.first;
      await _firestore.collection('time_slots').doc(timeSlotDoc.id).update({
        'available': false,
      });
    }

    await _firestore.collection('appointments').add({
      'patient_id': userId,
      'doctor_id': doctor['uid'],
      'doctor_name': doctor['name'],
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

  Future<void> cancelAppointment(String userId) async {
    // Cancel the appointment for the given user ID
    // This is just an example, you need to implement the actual query based on your data structure
    QuerySnapshot snapshot = await _firestore
        .collection('appointments')
        .where('patient_id', isEqualTo: userId)
        .get();

    for (var doc in snapshot.docs) {
      await _firestore.collection('appointments').doc(doc.id).delete();
    }
  }
}

class TimeSlotGenerator {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> generateTimeSlotsForDoctors() async {
    final doctors = await _firestore.collection('doctors').get();

    for (var doc in doctors.docs) {
      Map<String, dynamic> doctorData = doc.data();
      String doctorId = doc.id;
      List<String> workDays = List<String>.from(doctorData['work_days']);
      Map<String, String> workHours = Map<String, String>.from(doctorData['work_hours']);

      for (String day in workDays) {
        for (var entry in workHours.entries) {
          String startTime = entry.key;
          String endTime = entry.value;

          DateTime start = _parseTime(startTime);
          DateTime end = _parseTime(endTime);

          List<String> timeSlots = _generateTimeSlots(start, end);

          for (var time in timeSlots) {
            await _firestore.collection('time_slots').add({
              'date': DateFormat('yyyy-MM-dd').format(DateTime.now()), // Example date; adjust as needed
              'ailment_type': 'Dental', // Example; adjust based on actual ailments
              'time': time,
              'doctor_id': doctorId,
              'available': true
            });
          }
        }
      }
    }
  }

  DateTime _parseTime(String time) {
    return DateFormat('HH:mm').parse(time);
  }

  List<String> _generateTimeSlots(DateTime start, DateTime end) {
    List<String> slots = [];
    DateTime current = start;

    while (current.isBefore(end)) {
      slots.add(DateFormat('HH:mm').format(current));
      current = current.add(Duration(minutes: 30)); // Slot duration; adjust as needed
    }

    return slots;
  }
}


Future<void> generateTimeSlots() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    // Fetch all doctors
    QuerySnapshot doctorsSnapshot = await firestore.collection('doctors').get();

    for (var doctorDoc in doctorsSnapshot.docs) {
      String doctorId = doctorDoc.id;
      Map<String, dynamic> doctorData = doctorDoc.data() as Map<String, dynamic>;

      List<String> workingDays = List<String>.from(doctorData['working_days']);
      String startHour = doctorData['working_hours']['start'];
      String endHour = doctorData['working_hours']['end'];

      for (String day in workingDays) {
        await generateDailyTimeSlots(firestore, doctorId, day, startHour, endHour);
      }
    }
  } catch (e) {
    print('Error generating time slots: $e');
  }
}

Future<void> generateDailyTimeSlots(FirebaseFirestore firestore, String doctorId, String day, String startHour, String endHour) async {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime startTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse('${today.toIso8601String().split('T')[0]} $startHour:00');
  DateTime endTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse('${today.toIso8601String().split('T')[0]} $endHour:00');

  while (startTime.isBefore(endTime)) {
    String formattedTime = DateFormat('HH:mm').format(startTime);
    await firestore.collection('time_slots').add({
      'doctor_id': doctorId,
      'date': today.toIso8601String().split('T')[0],
      'time': formattedTime,
      'available': true,
    });

    startTime = startTime.add(Duration(minutes: 30)); // Assuming 30-minute slots
  }
}


Future<List<String>> getAvailableTimeSlots(DateTime date, String doctorId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Fetch all slots for the given date and doctor
  QuerySnapshot allSlotsSnapshot = await firestore.collection('time_slots')
      .where('date', isEqualTo: date.toIso8601String().split('T')[0])
      .where('doctor_id', isEqualTo: doctorId)
      .get();

  List<String> allSlots = [];
  for (var doc in allSlotsSnapshot.docs) {
    allSlots.add(doc['time']);
  }

  // Fetch booked slots for the given date
  QuerySnapshot bookedSlotsSnapshot = await firestore.collection('appointments')
      .where('date_time', isGreaterThanOrEqualTo: DateTime(date.year, date.month, date.day, 0, 0))
      .where('date_time', isLessThan: DateTime(date.year, date.month, date.day, 23, 59))
      .where('doctor_id', isEqualTo: doctorId)
      .get();

  List<String> bookedSlots = [];
  for (var doc in bookedSlotsSnapshot.docs) {
    bookedSlots.add(DateFormat('HH:mm').format(doc['date_time'].toDate()));
  }

  // Return only available slots
  return allSlots.where((slot) => !bookedSlots.contains(slot)).toList();
}