import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:patientpal_system/firebase_options.dart';
import 'package:patientpal_system/screens/appointment/create_appointment_page.dart';
import 'package:provider/provider.dart';
import 'package:patientpal_system/providers/doctor_provider.dart';
import 'package:patientpal_system/providers/appointment_provider.dart';
import 'package:patientpal_system/providers/auth_provider.dart';
import 'package:patientpal_system/screens/doctor/doctor_registration_page.dart';
import 'package:patientpal_system/screens/auth/login_page.dart';
import 'package:patientpal_system/screens/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform);
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
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PatientPal System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      routes: {
        '/registerDoctor': (context) => DoctorRegistrationPage(),
        '/home': (context) => HomePage(),
        '/createAppointment': (context) => CreateAppointmentPage(),
      },
    );
  }
}
