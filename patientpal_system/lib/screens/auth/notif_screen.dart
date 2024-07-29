import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patientpal_system/models/notifications_model.dart';
import 'package:patientpal_system/screens/home/home_page.dart';
// import 'package:patientpal_system/models/notifications_model.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        backgroundColor: Color.fromARGB(255, 38, 143, 124),
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(color: Colors.white, letterSpacing: .5),
          ),
        ),
      ),
      body: StreamBuilder<List<NotificationModel>>(
        stream: NotificationService().getNotifications(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data!;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return ListTile(
                title: Text(notification.title),
                subtitle: Text(notification.message),
                trailing: Text(
                  notification.timestamp.toLocal().toString(),
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
