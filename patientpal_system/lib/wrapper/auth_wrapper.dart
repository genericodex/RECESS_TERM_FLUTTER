// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:patientpal_system/providers/auth_provider.dart';
// import 'package:patientpal_system/screens/auth/login_page.dart';
// import 'package:patientpal_system/screens/home/home_page.dart';
// import 'package:provider/provider.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//         // Add other providers here
//       ],
//       child: MaterialApp(
//         home: AuthenticationWrapper(),
//       ),
//     );
//   }
// }

// class AuthenticationWrapper extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AuthProvider>(
//       builder: (context, authProvider, _) {
//         if (authProvider.isAuthenticated) {
//           return HomePage();
//         } else {
//           return LoginPage();
//         }
//       },
//     );
//   }
// }
