import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patientpal_system/screens/appointment/reschedule.dart';

class AppointmentDetailsPage extends StatelessWidget {
  final String appointmentId;

  AppointmentDetailsPage({required this.appointmentId});

  Future<Map<String, dynamic>> _getAppointmentDetails() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot appointmentSnapshot = await firestore.collection('appointments').doc(appointmentId).get();
    return appointmentSnapshot.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Appointment Details',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(color: Colors.white, letterSpacing: .5, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 38, 163, 143),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getAppointmentDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching appointment details.'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Appointment details not found.'));
          }

          final appointmentData = snapshot.data!;
          final String ailment = appointmentData['ailment'] ?? 'N/A';
          final String workDay = appointmentData['workDay'] ?? 'N/A';
          final String timeSlot = appointmentData['timeSlot'] ?? 'N/A';
          final DateTime? date = (appointmentData['date'] as Timestamp?)?.toDate();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.local_hospital, color: Color.fromARGB(255, 57, 156, 138)),
                      const SizedBox(width: 10),
                      Text('Ailment', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(ailment, style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87)),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Color.fromARGB(255, 57, 156, 138)),
                      const SizedBox(width: 10),
                      Text('Work Day', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(workDay, style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87)),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Color.fromARGB(255, 57, 156, 138)),
                      const SizedBox(width: 10),
                      Text('Time Slot', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(timeSlot, style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87)),
                  const SizedBox(height: 24),
                  if (date != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.date_range, color: Color.fromARGB(255, 57, 156, 138)),
                            const SizedBox(width: 10),
                            Text('Date', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat('EEEE, MMMM d, yyyy').format(date),
                          style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  Divider(color: Colors.grey[400]),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReschedulePage(appointmentId: appointmentId),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit_calendar, color: Colors.white),
                      label: Text(
                        'Reschedule Appointment',
                        style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 57, 156, 138),
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
