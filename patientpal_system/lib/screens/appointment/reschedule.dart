import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ReschedulePage extends StatefulWidget {
  final String appointmentId;

  ReschedulePage({required this.appointmentId});

  @override
  _ReschedulePageState createState() => _ReschedulePageState();
}

class _ReschedulePageState extends State<ReschedulePage> {
  String? _selectedTimeSlot;
  String? _selectedWorkDay;
  DateTime? _selectedDate;

  List<String> _workDays = [];
  List<Map<String, dynamic>> _availableTimeSlots = [];

  @override
  void initState() {
    super.initState();
    _fetchAppointmentDetails();
  }

  Future<void> _fetchAppointmentDetails() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot appointmentSnapshot = await firestore.collection('appointments').doc(widget.appointmentId).get();
    var appointmentData = appointmentSnapshot.data() as Map<String, dynamic>;
    
    // Fetch the work days for the doctor
    _fetchDoctorWorkDays(appointmentData['doctorId']);
  }

  Future<void> _fetchDoctorWorkDays(String doctorId) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentSnapshot doctorSnapshot = await firestore.collection('doctors').doc(doctorId).get();
      var doctorData = doctorSnapshot.data() as Map<String, dynamic>;

      setState(() {
        _workDays = List<String>.from(doctorData['working_days']);
      });
    } catch (e) {
      print('Error fetching doctor workdays: $e');
    }
  }

  Future<void> _fetchAvailableTimeSlots(String workDay) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;


      DocumentSnapshot appointmentSnapshot = await firestore.collection('appointments').doc(widget.appointmentId).get();
      var appointmentData = appointmentSnapshot.data() as Map<String, dynamic>;
      String doctorId = appointmentData['doctorId'];

      QuerySnapshot snapshot = await firestore
          .collection('time_slots')
          .where('isBooked', isEqualTo: false)
          .where('doctorId', isEqualTo: doctorId)
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

  Future<void> _rescheduleAppointment() async {
    if (_selectedTimeSlot != null && _selectedWorkDay != null) {
      _selectedDate = _getNextAvailableDate(_selectedWorkDay!);

      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('appointments').doc(widget.appointmentId).update({
        'timeSlot': _selectedTimeSlot,
        'workDay': _selectedWorkDay,
        'date': _selectedDate,
      });

      // Mark the new time slot as booked
      await firestore
          .collection('time_slots')
          .where('doctorId', isEqualTo: widget.appointmentId)
          .where('day', isEqualTo: _selectedWorkDay)
          .where('time', isEqualTo: _selectedTimeSlot)
          .get()
          .then((snapshot) {
        for (var doc in snapshot.docs) {
          doc.reference.update({'isBooked': true});
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Appointment rescheduled successfully!'),
        backgroundColor: Colors.green,
      ));

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select all required fields.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  DateTime _getNextAvailableDate(String workDay) {
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday;
    int targetWeekday = _getWeekdayIndex(workDay);

    int daysUntilNext = (targetWeekday - currentWeekday + 7) % 7;
    daysUntilNext = daysUntilNext == 0 ? 7 : daysUntilNext;

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

  Widget _buildCard(String day, VoidCallback onTap, bool isSelected) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 80,
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Color.fromARGB(255, 3, 71, 48) : Color.fromARGB(255, 229, 228, 228),
          ),
          borderRadius: BorderRadius.circular(12.0),
          color: isSelected ? Color.fromARGB(255, 38, 163, 143) : Color.fromARGB(255, 235, 235, 235),
        ),
        child: Center(
          child: Text(
            day,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reschedule Appointment',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(color: Colors.white, letterSpacing: .5, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 38, 163, 143),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Work Day:', style: GoogleFonts.poppins(fontSize: 18)),
            SizedBox(height: 32),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _workDays.map((day) {
                  bool isSelected = day == _selectedWorkDay;
                  return _buildCard(
                    day,
                    () {
                      setState(() {
                        _selectedWorkDay = day;
                        _selectedTimeSlot = null;
                        _fetchAvailableTimeSlots(day);
                      });
                    },
                    isSelected,
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 24),
            if (_availableTimeSlots.isNotEmpty) ...[
              Text('Available Time Slots:', style: GoogleFonts.poppins(fontSize: 18)),
              SizedBox(height: 12),
              Wrap(
                spacing: 8.0,
                children: _availableTimeSlots.map((slot) {
                  return ChoiceChip(
                    label: Text(
                      slot['time'],
                      style: GoogleFonts.poppins(),
                    ),
                    selected: _selectedTimeSlot == slot['time'],
                    onSelected: (selected) {
                      setState(() {
                        _selectedTimeSlot = slot['time'];
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 24),
            ],
            ElevatedButton(
              onPressed: _rescheduleAppointment,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 57, 156, 138),
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Text('Confirm Reschedule', style: GoogleFonts.poppins(fontSize: 16,color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
