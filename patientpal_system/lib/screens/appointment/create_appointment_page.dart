import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:patientpal_system/providers/auth_provider.dart';
import 'package:patientpal_system/screens/appointment/notifications.dart';
import 'package:patientpal_system/screens/home/home_page.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Added for date formatting and manipulation
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Import for notifications
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;



final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String? _selectedAilment;
  String? _selectedTimeSlot;
  String? _selectedDoctorId;
  String? _selectedWorkDay;
  DateTime? _selectedDate; // Added to store the selected date

  List<String> _ailments = ['Dental', 'Optics', 'General', 'ENT']; // Your ailment types
  List<String> _workDays = [];
  List<Map<String, dynamic>> _availableTimeSlots = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchDoctorWorkDays(String ailment) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot doctorSnapshot = await firestore
          .collection('doctors')
          .where('department', isEqualTo: ailment)
          .get();

      if (doctorSnapshot.docs.isNotEmpty) {
        String? selectedDoctorId;
        int minAppointments = double.maxFinite.toInt();

        for (var doc in doctorSnapshot.docs) {
          String doctorId = doc.id;
          QuerySnapshot appointmentSnapshot = await firestore
              .collection('appointments')
              .where('doctorId', isEqualTo: doctorId)
              .get();

          int appointmentCount = appointmentSnapshot.docs.length;
          if (appointmentCount < minAppointments) {
            minAppointments = appointmentCount;
            selectedDoctorId = doctorId;
          }
        }

        if (selectedDoctorId != null) {
          var doctorData = doctorSnapshot.docs.firstWhere((doc) => doc.id == selectedDoctorId).data() as Map<String, dynamic>;
          setState(() {
            _selectedDoctorId = selectedDoctorId;
            _workDays = List<String>.from(doctorData['working_days']);
          });
        }
      }
    } catch (e) {
      print('Error fetching doctor workdays: $e');
    }
  }

  Future<void> _fetchAvailableTimeSlots(String workDay) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot snapshot = await firestore
          .collection('time_slots')
          .where('isBooked', isEqualTo: false)
          .where('doctorId', isEqualTo: _selectedDoctorId)
          .where('day', isEqualTo: workDay)
          .get();

      List<Map<String, dynamic>> fetchedSlots = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      // Sort the time slots by the 'time' field
      fetchedSlots.sort((a, b) => a['time'].compareTo(b['time']));

      Set<String> uniqueTimes = Set<String>();
      List<Map<String, dynamic>> uniqueSlots = [];

      for (var slot in fetchedSlots) {
        if (uniqueTimes.add(slot['time'])) {
          uniqueSlots.add(slot);
        }
      }

      setState(() {
        _availableTimeSlots = uniqueSlots;
      });
    } catch (e) {
      print('Error fetching available time slots: $e');
    }
  }

  // Added function to calculate the next available date for the selected workday
  DateTime _getNextAvailableDate(String workDay) {
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday;
    int targetWeekday = _getWeekdayIndex(workDay);

    int daysUntilNext = (targetWeekday - currentWeekday + 7) % 7;
  daysUntilNext = daysUntilNext == 0 ? 7 : daysUntilNext; // Ensure it is in the next week

  return now.add(Duration(days: daysUntilNext));
  }

  int _getWeekdayIndex(String workDay) {
    switch (workDay) {
      case 'Monday':
        return DateTime.monday;
      case 'Tuesday':
        return DateTime.tuesday;
      case 'Wednesday':
        return DateTime.wednesday;
      case 'Thursday':
        return DateTime.thursday;
      case 'Friday':
        return DateTime.friday;
      case 'Saturday':
        return DateTime.saturday;
      case 'Sunday':
        return DateTime.sunday;
      default:
        return DateTime.monday;
    }
  }

  DateTime _getNextWeekdayDate(String workDay) {
  int dayIndex = _getWeekdayIndex(workDay);
  DateTime now = DateTime.now();
  int currentDayIndex = now.weekday;

  // Calculate the number of days until the next occurrence of the given day in the next week
  int daysUntilNext = (dayIndex - currentDayIndex + 7) % 7;
  daysUntilNext = daysUntilNext == 0 ? 7 : daysUntilNext; // Ensure it is in the next week

  return now.add(Duration(days: daysUntilNext));
}

Future<void> _scheduleNotification({
  required DateTime appointmentDate,
  required String doctorName,
  required String timeSlot,
}) async {
    final scheduledDate = tz.TZDateTime.from(appointmentDate.subtract(Duration(days: 1)), tz.local);

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'appointment_channel_id',
      'Appointment Reminders',
      channelDescription: 'Channel for appointment reminders',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Appointment Reminder',
      'You have an appointment with Dr. $doctorName on ${DateFormat('MMMM d, yyyy').format(appointmentDate)} at $timeSlot.',
      scheduledDate,
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }


  Future<void> showPopUpNotification(
    {required String title,
    required String body,
    bool playSound = true,
    bool vibrate = true}) async {
  AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'appointment_channel_id',
    'Appointment Notifications',
    channelDescription: 'Channel for appointment notifications',
    importance: Importance.high,
    priority: Priority.high,
    playSound: playSound,
    enableVibration: vibrate,
    vibrationPattern: vibrate
        ? Int64List.fromList([0, 1000, 500, 2000])
        : Int64List.fromList([0]), // Custom vibration pattern
  );

  NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID
    title,
    body,
    platformDetails,
  );
}

  Future<void> _bookAppointment() async {
  final user = context.read<AuthProvider>().user;

  if (_selectedAilment != null && _selectedTimeSlot != null && _selectedWorkDay != null) {
    _selectedDate = _getNextAvailableDate(_selectedWorkDay!);

    print('Selected Ailment: $_selectedAilment');
    print('Selected Time Slot: $_selectedTimeSlot');
    print('Selected Work Day: $_selectedWorkDay');
    print('Selected Date: $_selectedDate');

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var appointment = {
      'doctorId': _selectedDoctorId,
      'patient_id': user!.uid,
      'ailment': _selectedAilment,
      'timeSlot': _selectedTimeSlot,
      'workDay': _selectedWorkDay,
      'date': _selectedDate, // Store the selected date
      'isBooked': true,
    };

    try {
      await firestore.collection('appointments').add(appointment);
      await firestore
          .collection('time_slots')
          .where('doctorId', isEqualTo: _selectedDoctorId)
          .where('day', isEqualTo: _selectedWorkDay)
          .where('time', isEqualTo: _selectedTimeSlot)
          .get()
          .then((snapshot) {
        for (var doc in snapshot.docs) {
          doc.reference.update({'isBooked': true});
        }
      });
      DocumentSnapshot doctorDoc = await firestore.collection('doctors').doc(_selectedDoctorId).get();
      Map<String, dynamic>? data = doctorDoc.data() as Map<String, dynamic>?;
      String doctorName = data?['name'] ?? 'Unknown Doctor';
      String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);


      await showPopUpNotification(
    title: 'Appointment Created',
    body: 'Your appointment with Dr. $doctorName on $formattedDate at $_selectedTimeSlot has been successfully created.',
    playSound: true, // Set to false if you don't want sound
    vibrate: true, // Set to false if you don't want vibration
  );


      if (_selectedDate != null) {
        await scheduleReminderNotification(
        title: 'Appointment Reminder',
        body: 'Your appointment with Dr. $doctorName is in 15 hours on $formattedDate at $_selectedTimeSlot.',
        appointmentDate: _selectedDate!, // Pass the selected date,
      );
      }

      // Save notification to Firestore
      await saveNotification(
        'Upcoming Reminder',
        'You have an appointment with Dr. $doctorName on $_selectedWorkDay $formattedDate at $_selectedTimeSlot.',
      );

      setState(() {
        _selectedAilment = null;
        _selectedTimeSlot = null;
        _selectedWorkDay = null;
        _workDays = [];
        _availableTimeSlots = [];
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Appointment booked successfully!'),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      print('Error booking appointment: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to book appointment.'),
        backgroundColor: Colors.red,
      ));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Please select all required fields.'),
      backgroundColor: Color.fromARGB(255, 255, 0, 0),
    ));
  }
}


  Widget _buildCard(String day, VoidCallback onTap, bool isSelected) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Color.fromARGB(255, 3, 71, 48) : Color.fromARGB(255, 229, 228, 228),
            width: 1,
          ),
          color: isSelected ? Color.fromARGB(255, 57, 156, 138) : Colors.grey[50],
          borderRadius: BorderRadius.circular(36.0),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              day,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: isSelected ? Color.fromARGB(255, 184, 247, 226) : Color.fromARGB(255, 22, 4, 56),
                  letterSpacing: .5,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (Route<dynamic> route) => false,
            );
          },
        ),
        title: Text(
          'Make Appointment',
          style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white, letterSpacing: .5, fontWeight: FontWeight.bold)),
        ),
        backgroundColor: Color.fromARGB(255, 38, 163, 143),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Ailment Type',
                  style: GoogleFonts.anuphan(
                    textStyle: TextStyle(
                      color: Color.fromARGB(255, 22, 4, 56),
                      letterSpacing: .5,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              SizedBox(height: 8),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _ailments.map((ailment) {
                    return _buildCard(
                      ailment,
                      () {
                        setState(() {
                          _selectedAilment = ailment;
                          _workDays = [];
                          _availableTimeSlots = [];
                          _selectedWorkDay = null;
                          _selectedTimeSlot = null;
                        });
                        _fetchDoctorWorkDays(ailment);
                      },
                      _selectedAilment == ailment,
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 16),
              Text('Select Work Day',
                  style: GoogleFonts.anuphan(
                    textStyle: TextStyle(
                      color: Color.fromARGB(255, 22, 4, 56),
                      letterSpacing: .5,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              SizedBox(height: 8),
              _workDays.isEmpty
                  ? Center(
                      child: Text(
                        'Please select an ailment type.',
                        style: GoogleFonts.poppins(textStyle: TextStyle(color: Color.fromARGB(255, 57, 156, 138), letterSpacing: .5)),
                      ),
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: _workDays.map((day) {
                          return _buildCard(
                            day,
                            () {
                              setState(() {
                                _selectedWorkDay = day;
                                _availableTimeSlots = [];
                                _selectedTimeSlot = null;
                              });
                              _fetchAvailableTimeSlots(day);
                            },
                            _selectedWorkDay == day,
                          );
                        }).toList(),
                      ),
                    ),
              SizedBox(height: 16),
              Text('Select Time',
                  style: GoogleFonts.anuphan(
                    textStyle: TextStyle(
                      color: Color.fromARGB(255, 22, 4, 56),
                      letterSpacing: .5,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              _availableTimeSlots.isEmpty
                  ? Center(
                      child: Text(
                        'Please select a work day.',
                        style: GoogleFonts.poppins(textStyle: TextStyle(color: Color.fromARGB(255, 57, 156, 138), letterSpacing: .5)),
                      ),
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: _availableTimeSlots.map((slot) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedTimeSlot = slot['time'];
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.14,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _selectedTimeSlot == slot['time']
                                        ? Color.fromARGB(255, 3, 71, 48)
                                        : Color.fromARGB(255, 229, 228, 228),
                                    width: 1,
                                  ),
                                  color: _selectedTimeSlot == slot['time']
                                      ? Color.fromARGB(255, 57, 156, 138)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${slot['time']}',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          color: _selectedTimeSlot == slot['time']
                                              ? Color.fromARGB(255, 184, 247, 226)
                                              : Color.fromARGB(255, 1, 136, 102),
                                          letterSpacing: .5,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 20,),
              if (_selectedDate != null) // Display selected date
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child:Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 223, 253, 250),
          borderRadius: BorderRadius.circular(20.0),
          
        ),
        child: Text(
          'Selected Date: ${DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate!)}',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: Colors.black,
              letterSpacing: .5,
              fontSize: 16,
            ),
          ),
        ),
      ),
    ),
                ),
              SizedBox(height: 16),
              Divider(
                color: Colors.grey[400],
                thickness: 0.5,
              ),
              SizedBox(height: 44),
              Center(
                child: ElevatedButton(
                  onPressed: _bookAppointment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 57, 156, 138),
                    foregroundColor: Colors.white,
                    elevation: 3.0,
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    textStyle: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      inherit: true,
                    ),
                  ),
                  child: Text(
                    'Book Appointment',
                    style: GoogleFonts.anuphan(
                      textStyle: TextStyle(
                        color: Colors.grey[50],
                        letterSpacing: .5,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
