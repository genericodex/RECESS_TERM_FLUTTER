import 'package:e_mergency_app/screens/emergency/emergency_history_screen.dart';
import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'appointments/appointment_list_screen.dart';
import 'chat/chat_list_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'E-mergency',
            style: TextStyle(color: Colors.white),
            
            ),
        ),
          backgroundColor: Color.fromARGB(255, 8, 16, 7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: <Widget>[
            _buildCard(
              context,
              title: 'Appointments',
              icon: Icons.calendar_today,
              screen: AppointmentsListScreen(),
            ),
            _buildCard(
              context,
              title: 'Emergency',
              icon: Icons.warning,
              screen: EmergencyHistoryScreen(),
            ),
            _buildCard(
              context,
              title: 'Contact Doctor',
              icon: Icons.chat,
              screen: ChatListScreen(),
            ),
            _buildCard(
              context,
              title: 'Profile',
              icon: Icons.person,
              screen: ProfileScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required String title, required IconData icon, required Widget screen}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 40, color: Colors.blue),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
