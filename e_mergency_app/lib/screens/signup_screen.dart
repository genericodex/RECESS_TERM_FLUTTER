import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'First Name'),
              onChanged: (value) => authProvider.firstName = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Last Name'),
              onChanged: (value) => authProvider.lastName = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Student Number'),
              onChanged: (value) => authProvider.studentNumber = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Reg Number'),
              onChanged: (value) => authProvider.regNumber = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Phone Number'),
              onChanged: (value) => authProvider.phoneNumber = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Email/Webmail'),
              onChanged: (value) => authProvider.email = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              onChanged: (value) => authProvider.password = value,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                authProvider.signup();
                Navigator.pop(context);
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
