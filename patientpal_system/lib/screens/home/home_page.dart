import 'package:flutter/material.dart';
import 'package:patientpal_system/screens/appointment/appointment_page.dart';
import 'package:provider/provider.dart';
import 'package:patientpal_system/providers/auth_provider.dart';
// import 'package:patientpal_system/screens/doctor/doctor_registration_page.dart';
import 'package:patientpal_system/screens/auth/login_page.dart';
// import 'package:patientpal_system/screens/appointment/create_appointment_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/registerDoctor');
              },
              child: Text('Register Doctor'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/createAppointment');
              },
              child: Text('Create Appointment'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AppointmentsPage()),
                );
              },
              child: Text('View Appointments'),
            ),
          ],
        ),
      ),
    );
  }
}
