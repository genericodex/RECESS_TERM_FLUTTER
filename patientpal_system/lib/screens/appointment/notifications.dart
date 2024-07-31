import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'You have no notifications right now',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:provider/provider.dart';
// import 'package:patientpal_system/providers/auth_provider.dart';

// class NotificationService {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   Future<void> initialize() async {
//     const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

//     final InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//     );

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   Future<void> scheduleNotification(DateTime scheduledDate, String title, String body, int id) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'appointment_reminder_channel',
//       'Appointment Reminders',
//       channelDescription: 'Channel for appointment reminders',
//       importance: Importance.max,
//       priority: Priority.high,
//       showWhen: true,
//     );

//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//     );

//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       scheduledDate,
//       platformChannelSpecifics,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }
// }

// class AppointmentReminderPage extends StatefulWidget {
//   @override
//   _AppointmentReminderPageState createState() => _AppointmentReminderPageState();
// }

// class _AppointmentReminderPageState extends State<AppointmentReminderPage> {
//   final NotificationService _notificationService = NotificationService();

//   @override
//   void initState() {
//     super.initState();
//     _notificationService.initialize();
//     _scheduleUpcomingAppointmentsNotifications();
//   }

//   Future<void> _scheduleUpcomingAppointmentsNotifications() async {
//     final user = context.read<AuthProvider>().user;

//     if (user != null) {
//       FirebaseFirestore.instance
//           .collection('appointments')
//           .where('patient_id', isEqualTo: user.uid)
//           .where('isBooked', isEqualTo: true)
//           .snapshots()
//           .listen((snapshot) {
//         for (var doc in snapshot.docs) {
//           Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//           Timestamp appointmentTimestamp = data['date'];
//           DateTime appointmentDate = appointmentTimestamp.toDate();
//           String timeSlot = data['timeSlot'];
//           String doctorId = data['doctorId'];

//           _scheduleNotificationForAppointment(appointmentDate, timeSlot, doctorId, doc.id);
//         }
//       });
//     }
//   }

//   Future<void> _scheduleNotificationForAppointment(DateTime appointmentDate, String timeSlot, String doctorId, String appointmentId) async {
//     DateTime scheduledNotificationDate = appointmentDate.subtract(Duration(minutes: 30));

//     // Fetch doctor's name for the notification body
//     DocumentSnapshot doctorSnapshot = await FirebaseFirestore.instance.collection('doctors').doc(doctorId).get();
//     String doctorName = doctorSnapshot.exists ? doctorSnapshot['name'] : 'Your doctor';

//     String notificationTitle = 'Upcoming Appointment';
//     String notificationBody = 'You have an appointment with Dr. $doctorName at $timeSlot.';

//     int notificationId = int.parse(appointmentId.hashCode.toString().substring(0, 6));
//     _notificationService.scheduleNotification(scheduledNotificationDate, notificationTitle, notificationBody, notificationId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Appointment Reminders'),
//       ),
//       body: Center(
//         child: Text('Notifications will remind you of your upcoming appointments.'),
//       ),
//     );
//   }
// }
