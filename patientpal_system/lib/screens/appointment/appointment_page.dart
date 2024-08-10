import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patientpal_system/screens/appointment/appointment_details.dart';
import 'package:patientpal_system/screens/home/home_page.dart';
import 'package:provider/provider.dart';
import 'package:patientpal_system/providers/auth_provider.dart';
import 'create_appointment_page.dart';
import 'package:intl/intl.dart'; // For date formatting

class AppointmentsPage extends StatelessWidget {
  Future<String> _fetchDoctorName(String doctorId) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('doctors').doc(doctorId).get();
      Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;
      return data?['name'] ?? 'Unknown Doctor';
    } catch (e) {
      print('Error fetching doctor name: $e');
      return 'Unknown Doctor';
    }
  }

  Future<Card> _buildAppointmentCard(Map<String, dynamic> data, String appointmentId, BuildContext context) async {
    String? dateTime = data['timeSlot'] as String?;
    String? day = data['workDay'] as String?;
    String ailmentType = data['ailment'] as String;
    bool status = data['isBooked'] as bool;
    String doctorId = data['doctorId'] as String;
    Timestamp? timestamp = data['date'] as Timestamp?;

    // Fetch doctor's name
    String doctorName = await _fetchDoctorName(doctorId);

    // Format the date if it exists
    String formattedDate = timestamp != null ? DateFormat('MMMM d, yyyy').format(timestamp.toDate()) : 'Unknown Date';

    return Card(
      color: Colors.grey[50],
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: Color.fromARGB(255, 2, 107, 77), width: .5),
      ),
      child: GestureDetector(
        onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppointmentDetailsPage(appointmentId: appointmentId),
          ),
        );
      },
        child: ListTile(
          contentPadding: EdgeInsets.all(11.0),
          leading: Icon(
            FontAwesomeIcons.calendarCheck,
            color: Color.fromARGB(255, 38, 163, 143),
            size: 50,
          ),
          title: Text(
            dateTime != null ? 'Appointment on $day $formattedDate at $dateTime' : 'Appointment date not set',
            style: GoogleFonts.anuphan(
              textStyle: TextStyle(
                color: const Color.fromARGB(255, 22, 4, 56), 
                letterSpacing: .5,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.0),
              Text(
                'Ailment: $ailmentType',
                style: GoogleFonts.poppins(textStyle: TextStyle(color: Color.fromARGB(255, 38, 163, 143), letterSpacing: .5,fontSize: 16)),
              ),
              SizedBox(height: 4.0),
              Text(
                'Doctor: $doctorName',
                style: GoogleFonts.poppins(textStyle: TextStyle(color: Color.fromARGB(255, 38, 163, 143), letterSpacing: .5,fontSize: 16)),
              ),
              SizedBox(height: 4.0),
              Text(
                status ? 'Status: Booked' : 'Status: Available',
                style: GoogleFonts.poppins(textStyle: TextStyle(color: Color.fromARGB(255, 133, 134, 136), letterSpacing: .5,fontSize: 14)),
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.cancel),
            color: Color.fromARGB(255, 171, 38, 19),
            onPressed: () async {
              await _cancelAppointment(context, appointmentId);
            },
          ),
        ),
      ),
    );
  }

  Future<void> _cancelAppointment(BuildContext context, String appointmentId) async {
    try {
      await FirebaseFirestore.instance.collection('appointments').doc(appointmentId).delete();
      await FirebaseFirestore.instance
          .collection('time_slots')
          .where('appointmentId', isEqualTo: appointmentId)
          .get()
          .then((snapshot) {
        for (var doc in snapshot.docs) {
          doc.reference.update({'isBooked': false});
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
        'Appointment canceled', 
        style: GoogleFonts.poppins(
        textStyle: TextStyle(
        color: Colors.white, 
        fontSize: 16, letterSpacing: .5
        )
        )),
        backgroundColor: Colors.green,),
      );
    } catch (e) {
      print('Error canceling appointment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel appointment')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 38, 163, 143),
        title: Text('My Appointments', style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white, letterSpacing: .5, fontWeight:FontWeight.bold))),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (Route<dynamic> route) => false,
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookingPage()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('patient_id', isEqualTo: user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No appointments found', style: TextStyle(fontSize: 18, color: Colors.grey)));
          }

          // Process the documents asynchronously
          return FutureBuilder<List<Widget>>(
            future: Future.wait(
              snapshot.data!.docs.map((doc) async {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                return await _buildAppointmentCard(data, doc.id, context);
              }).toList(),
            ),
            builder: (context, futureSnapshot) {
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (futureSnapshot.hasError) {
                return Center(child: Text('Error: ${futureSnapshot.error}'));
              }

              return ListView(
                padding: EdgeInsets.all(16.0),
                children: futureSnapshot.data ?? [],
              );
            },
          );
        },
      ),
    );
  }
}
