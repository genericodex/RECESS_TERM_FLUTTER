import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:patientpal_system/main.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;



Future<void> scheduleReminderNotification({
  required String title,
  required String body,
  required DateTime appointmentDate,
}) async {
  // Calculate the scheduled time, 14 hours before the appointment
  final scheduledDate = tz.TZDateTime.from(
    appointmentDate.subtract(Duration(hours: 14)),
    tz.local,
  );

  // Define notification details
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'reminder_channel_id',
    'Appointment Reminders',
    channelDescription: 'Channel for appointment reminders',
    importance: Importance.high,
    priority: Priority.high,
  );

  const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

  // Schedule the notification
  await flutterLocalNotificationsPlugin.zonedSchedule(
    1, // Notification ID, should be unique
    title,
    body,
    scheduledDate,
    platformDetails,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    androidAllowWhileIdle: true, // To wake the device if needed
  );
}
  


class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      letterSpacing: .5,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  )
          ),
        backgroundColor: Color.fromARGB(255, 38, 163, 143),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('notifications').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'You have no notifications right now',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 22, 4, 56),
                  ),
                ),
              ),
            );
          }

          return ListView(
            padding: EdgeInsets.all(16.0),
            children: snapshot.data!.docs.map((doc) {
              DateTime timestamp = doc['timestamp'].toDate();
              return Card(
                color: Color.fromARGB(255, 240, 255, 248),
                elevation: 2,
                shadowColor: Color.fromARGB(125, 25, 229, 113),
                margin: EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  title: Text(
                    doc['title'],
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    doc['body'],
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                  trailing: Text(
                    DateFormat('MMM d, yyyy - h:mm a').format(timestamp),
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey[600],
                    ),
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


Future<void> saveNotification(String title, String body) async {
  await FirebaseFirestore.instance.collection('notifications').add({
    'title': title,
    'body': body,
    'timestamp': FieldValue.serverTimestamp(),
    
  });
}

