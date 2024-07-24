import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:patientpal_system/providers/auth_provider.dart';
import 'create_appointment_page.dart';

class AppointmentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Appointments', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
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

          return ListView(
            padding: EdgeInsets.all(16.0),
            children: snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              Timestamp dateTime = data['date_time'];
              String ailmentType = data['ailment_type'];
              String status = data['status'];

              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  leading: Icon(
                    Icons.calendar_today,
                    color: Colors.teal,
                    size: 40,
                  ),
                  title: Text(
                    'Appointment on ${dateTime.toDate().toLocal()}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.0),
                      Text(
                        'Ailment: $ailmentType',
                        style: TextStyle(fontSize: 16, color: Colors.teal),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'Status: $status',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.teal,
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
