import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:patientpal_system/providers/auth_provider.dart';
import 'package:patientpal_system/screens/home/home_page.dart';

class LoginPackage extends StatelessWidget {
  const LoginPackage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginScreen(),
    );   
  }
}



// LoginScreen.dart
class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'LOGIN',
      logo: AssetImage('assets/icons/app_icon.png'),
      onLogin: (loginData) => _authenticateUser(context, loginData),
      onSignup: (signupData) => _signupUser(context, signupData),
      onSubmitAnimationCompleted: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage())); // Navigate to MyHomePage
      },
      onRecoverPassword: _recoverPassword,
      theme: LoginTheme(
        primaryColor: const Color.fromARGB(255, 215, 249, 216),
        accentColor: Colors.white,
        errorColor: Colors.red,
        titleStyle: TextStyle(
          color: Color.fromARGB(255, 9, 23, 8),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        bodyStyle: TextStyle(
          color: Color.fromARGB(255, 44, 188, 15),
        ),
        textFieldStyle: TextStyle(
          color: Colors.black,
        ),
        buttonStyle: TextStyle(
          color: Colors.white,
        ),
        cardTheme: CardTheme(
          color: Color.fromARGB(255, 158, 238, 205),
          elevation: 5,
          margin: EdgeInsets.only(top: 15),
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
        inputTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          errorStyle: TextStyle(
            backgroundColor: Colors.red,
            color: Colors.white,
          ),
          labelStyle: TextStyle(fontSize: 12),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 12, 227, 55)),
          ),
        ),
        buttonTheme: LoginButtonTheme(
          splashColor: Color.fromARGB(255, 220, 214, 239),
          backgroundColor: Color.fromARGB(255, 63, 165, 87),
          highlightColor: Colors.green,
          elevation: 9.0,
          highlightElevation: 6.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          // true if you want to add a borderRadius on all buttons.
          // If you don't want to add a borderRadius to one of the button, just add
          // it to the corresponding buttonTheme
          //radius: 30.0,
        ),
      ),
    );
  }
}

Future<String?> _authenticateUser(BuildContext context, LoginData data) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      await authProvider.login(data.name, data.password);
      return null;
    } catch (e) {
      return 'Login failed: ${e.toString()}';
    }
  }

  Future<String?> _signupUser(BuildContext context, SignupData data) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      await authProvider.register(data.name!, data.password!);
      return null;
    } catch (e) {
      return 'Registration failed: ${e.toString()}';
    }
  }

  Future<String?> _recoverPassword(String name) async {
    // Implement your password recovery logic here
    return null;
  }