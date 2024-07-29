import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:patientpal_system/providers/auth_provider.dart';
import 'package:patientpal_system/screens/home/home_page.dart';
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
      // height: 10,
      width: 120,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Color.fromARGB(255, 3, 71, 48) : Color.fromARGB(255, 229, 228, 228), // Border color
          width: 2.0, // Border width
        ),
        color: isSelected ? Color.fromARGB(255, 2, 99, 75) : Colors.white,
        borderRadius: BorderRadius.circular(36.0),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            day,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: isSelected ? Color.fromARGB(255, 184, 247, 226) : Color.fromARGB(255, 1, 136, 102),
                letterSpacing: .5,
                fontSize: 15,
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
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
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
        title: Text('Book an Appointment',
        style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white, letterSpacing: .5)),
        ),
        backgroundColor: Color.fromARGB(255, 24, 176, 151),
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
                height: MediaQuery.of(context).size.height * 0.07,
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
                          height: MediaQuery.of(context).size.height * 0.07,
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
            : Color.fromARGB(255, 229, 228, 228), // Border color
            width: 2.0, // Border width
          ),
                      color: _selectedTimeSlot == slot['time']
                          ? Color.fromARGB(255, 2, 85, 64) 
                          : Colors.white,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${slot['time']}',
                                  style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: _selectedTimeSlot == slot['time'] 
                          ? Color.fromARGB(255, 184, 247, 226) 
                          : Color.fromARGB(255, 1, 136, 102),
                  letterSpacing: .5,
                  fontSize: 15,
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
                    backgroundColor: Color.fromARGB(255, 2, 85, 64) , // Background color
                    foregroundColor: Colors.white, // Text color
                    elevation: 3.0, // Shadow elevation
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0), // Button padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), // Rounded corners
                       // Border color and width
                    ),
                    textStyle: TextStyle(
                      fontSize: 16.0, // Text size
                      fontWeight: FontWeight.bold, // Text weight
                      color: Colors.white, // Ensure consistent text color
                      inherit: true, // Ensure inherit is true for consistency
                    ),
                  ),
                  child: Text(
                    'Book Appointment',
                    style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Color.fromARGB(255, 184, 247, 226),
                letterSpacing: .5,
                fontSize: 15,
                )
              )
                    ),
                ),
              )
        
        
            ],
          ),
        ),
      ),
    );
  }
}
