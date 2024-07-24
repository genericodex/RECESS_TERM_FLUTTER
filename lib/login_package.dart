// login_package.dart
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart'; // Ensure this package is added in pubspec.yaml
import 'main.dart'; // Import the main.dart to access MyHomePage

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
      onLogin: _authenticateUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacementNamed(MyHomePage.routeName); // Navigate to MyHomePage
      },
      onRecoverPassword: _recoverPassword,
    );
  }

  Future<String?> _authenticateUser(LoginData data) async {
    // Authenticate user
    return null;
  }

  Future<String?> _signupUser(SignupData data) async {
    // Signup user
    return null;
  }

  Future<String?> _recoverPassword(String name) async {
    // Recover password
    return null;
  }
}
