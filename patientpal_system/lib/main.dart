import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:patientpal_system/firebase_options.dart';
import 'package:patientpal_system/providers/notif_service.dart';
import 'package:patientpal_system/screens/appointment/create_appointment_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:patientpal_system/providers/doctor_provider.dart';
import 'package:patientpal_system/providers/appointment_provider.dart';
import 'package:patientpal_system/providers/auth_provider.dart';
import 'package:patientpal_system/screens/doctor/doctor_registration_page.dart';
import 'package:patientpal_system/screens/auth/login_page.dart';
import 'package:patientpal_system/screens/home/home_page.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {

     await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    tz.initializeTimeZones();


    final InitializationSettings initializationSettings = const InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/iconlogo'),
    iOS: DarwinInitializationSettings(),
    );

   
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // Handle foreground messages here
    if (message.notification != null) {
      flutterLocalNotificationsPlugin.show(
        message.notification.hashCode,
        message.notification!.title,
        message.notification!.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'appointment_channel_id',
            'Appointment Notifications',
            importance: Importance.max,
            priority: Priority.high,
            channelDescription: 'Channel for appointment notifications',
          ),
        ),
        );
      }
    });

    

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => DoctorProvider()),
          ChangeNotifierProvider(create: (_) => AppointmentProvider()),
        ],
        child: MyApp(),
      ),
    );

    // await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    // Generating time slots after initializing the app
    await fetchAppointmentsAndScheduleNotifications();
  } catch (e) {
    print('Error initializing Firebase or fetching Firestore data: $e');
    runApp(ErrorApp());
  }
}

Future<void> generateDailyTimeSlots(FirebaseFirestore firestore, String doctorId, String day, String startTime, String endTime) async {
  try {
    // Ensure times are in the correct format
    DateFormat inputFormat = DateFormat("H:mm");
    DateFormat outputFormat = DateFormat("HH:mm");

    DateTime startDateTime = inputFormat.parse(startTime);
    DateTime endDateTime = inputFormat.parse(endTime);

    // Reformat times to ensure leading zeros
    startTime = outputFormat.format(startDateTime);
    endTime = outputFormat.format(endDateTime);

    startDateTime = DateTime.parse("2000-01-01 $startTime:00");
    endDateTime = DateTime.parse("2000-01-01 $endTime:00");

    List<Map<String, dynamic>> timeSlots = [];
    while (startDateTime.isBefore(endDateTime)) {
      String timeSlot = startDateTime.toIso8601String().substring(11, 16);
      timeSlots.add({
        'doctorId': doctorId,
        'day': day,
        'time': timeSlot,
        'isBooked': false,
      });

      startDateTime = startDateTime.add(const Duration(minutes: 30));
    }

    for (var slot in timeSlots) {
      await firestore.collection('time_slots').add(slot);
    }
  } catch (e) {
    print('Error generating daily time slots: $e');
  }
}

Future<void> generateTimeSlots(FirebaseFirestore firestore) async {
  try {
    QuerySnapshot doctorSnapshot = await firestore.collection('doctors').get();
    if (doctorSnapshot.docs.isEmpty) {
      print('No doctors found in the Firestore collection.');
    } else {
      for (var doc in doctorSnapshot.docs) {
        print('Processing doctor with ID: ${doc.id}');
        Map<String, dynamic> doctorData = doc.data() as Map<String, dynamic>;
        List<String> workDays = List<String>.from(doctorData['working_days']);
        Map<String, String> workHours = Map<String, String>.from(doctorData['working_hours']);

        for (String day in workDays) {
          await generateDailyTimeSlots(firestore, doc.id, day, workHours['start']!, workHours['end']!);
        }
      }
    }
  } catch (e) {
    print('Error generating time slots: $e');
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PatientPal',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const LoginScreen(),
      routes: {
        '/registerDoctor': (context) => DoctorRegistrationPage(),
        '/home': (context) => HomePage(),
        '/createAppointment': (context) => BookingPage(),
      },
    );
  }
}

class ErrorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PatientPal System',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Error initializing the app. Please try again later.'),
        ),
      ),
    );
  }
}