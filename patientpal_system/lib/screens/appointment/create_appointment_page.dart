import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:patientpal_system/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';


class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String? _selectedAilment;
  String? _selectedTimeSlot;
  String? _selectedDoctorId;
  String? _selectedWorkDay;

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
        var doctor = doctorSnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          _selectedDoctorId = doctorSnapshot.docs.first.id;
          _workDays = List<String>.from(doctor['working_days']);
        });
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

      setState(() {
        _availableTimeSlots = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      });
    } catch (e) {
      print('Error fetching available time slots: $e');
    }
  }

  Future<void> _bookAppointment() async {
    final user = context.read<AuthProvider>().user;

    if (_selectedAilment != null && _selectedTimeSlot != null && _selectedWorkDay != null) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      var appointment = {
        'doctorId': _selectedDoctorId,
        'patient_id': user!.uid,
        'ailment': _selectedAilment,
        'timeSlot': _selectedTimeSlot,
        'workDay': _selectedWorkDay,
        'isBooked': true,
      };

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

      setState(() {
        _selectedAilment = null;
        _selectedTimeSlot = null;
        _selectedWorkDay = null;
        _workDays = [];
        _availableTimeSlots = [];
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Appointment booked successfully!'), backgroundColor: Colors.green,));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select all required fields.'),backgroundColor: Color.fromARGB(255, 255, 0, 0),));
    }
  }

 Widget _buildCard(String day, VoidCallback onTap, bool isSelected) {
  // bool isSelected = _selectedWorkDay == day;

  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: MediaQuery.of(context).size.width * 0.4,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Color.fromARGB(255, 30, 181, 108) : Color.fromARGB(255, 229, 228, 228), // Border color
          width: 2.0, // Border width
        ),
        color: isSelected ? Color.fromARGB(255, 170, 253, 196) : Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        // boxShadow: [
        //   if (isSelected)
        //     BoxShadow(
        //       color: Color.fromARGB(255, 1, 69, 39).withOpacity(0.5),
        //       spreadRadius: 2,
        //       blurRadius: 5,
        //     ),
        // ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            day,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: isSelected ? Color.fromARGB(255, 0, 45, 6) : Color.fromARGB(255, 0, 175, 62),
                letterSpacing: .5,
                fontSize: 20,
                )
              )
          ),
        ),
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(
        title: Text('Book an Appointment',
        style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white, letterSpacing: .5)),
        ),
        backgroundColor: Color.fromARGB(255, 24, 176, 123),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Ailment Type', style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.black, 
                  letterSpacing: .5,
                  fontSize: 20,
                  )
                )
              ),
              SizedBox(height: 8),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _ailments.map((ailment) {
                    return _buildCard(ailment, () async {
                      setState(() {
                        _selectedAilment = ailment;
                      });
                      await _fetchDoctorWorkDays(ailment);
                    },
                    _selectedAilment == ailment,
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 16),
              Divider(
                color: Colors.grey[400], // Change this to your preferred color
                thickness: 0.5,
              ),
              SizedBox(height: 16),
              _workDays.isEmpty
                  ? Center(child: Text('Please select an ailment.', style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.black, letterSpacing: .5)),),)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Select Work Day', style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.black, 
                  letterSpacing: .5,
                  fontSize: 20,
                  )
                )),
                        SizedBox(height: 8),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: _workDays.map((day) {
                              return _buildCard(day, () async {
                                setState(() {
                                  _selectedWorkDay = day;
                                });
                                await _fetchAvailableTimeSlots(day);
                              },
                              _selectedWorkDay == day,
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
              Divider(
                color: Colors.grey[400], // Change this to your preferred color
                thickness: 0.5,
              ),
              SizedBox(height: 16),
              Text('Select Time', style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.black, 
                  letterSpacing: .5,
                  fontSize: 20,
                  )
                )),
              // Displaying available time slots in a horizontal row
        _availableTimeSlots.isEmpty
            ? Center(child: Text('Please select a work day.', style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.black, letterSpacing: .5)),),)
            : SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _availableTimeSlots.map((slot) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTimeSlot = slot['time'];
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      border: Border.all(
            color: _selectedTimeSlot == slot['time'] ? Color.fromARGB(255, 30, 181, 108) : Color.fromARGB(255, 229, 228, 228), // Border color
            width: 2.0, // Border width
          ),
                      color: _selectedTimeSlot == slot['time']
                          ? Color.fromARGB(255, 170, 253, 196)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${slot['time']}',
                                  style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: _selectedTimeSlot == slot['time'] 
                                    ? Color.fromARGB(255, 0, 45, 6)
                                    : Color.fromARGB(255, 0, 175, 62),
                  letterSpacing: .5,
                  fontSize: 20,
                  )
                )
                                ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 16),
              Divider(
                color: Colors.grey[400], // Change this to your preferred color
                thickness: 0.5,
              ),
        
              SizedBox(height: 44),
              Center(
                child: ElevatedButton(
                  onPressed: _bookAppointment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 150, 80), // Background color
                    foregroundColor: Colors.white, // Text color
                    elevation: 3.0, // Shadow elevation
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0), // Button padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), // Rounded corners
                      side: BorderSide(color: const Color.fromARGB(255, 100, 255, 131), width: 2.0), // Border color and width
                    ),
                    textStyle: TextStyle(
                      fontSize: 16.0, // Text size
                      fontWeight: FontWeight.bold, // Text weight
                      color: Colors.white, // Ensure consistent text color
                      inherit: true, // Ensure inherit is true for consistency
                    ),
                  ),
                  child: Text('Book Appointment'),
                ),
              )
        
        
            ],
          ),
        ),
      ),
    );
  }
}
