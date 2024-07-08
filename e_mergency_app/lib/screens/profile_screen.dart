import 'package:flutter/material.dart';
import '../models/user.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User _user = User(
    firstName: 'John',
    lastName: 'Doe',
    email: 'john.doe@example.com',
    phone: '123-456-7890',
    studentNumber: '2021001',
    regNumber: 'REG2021001',
  );

  void _updateUser(User user) {
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Profile'),
      //   backgroundColor: Colors.black,
      //   foregroundColor: Colors.white,
      // ),
      body: Container(
        color: Color.fromARGB(255, 221, 246, 219),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('My profile',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black),
                ),
                SizedBox(height: 60,),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/photos/user1.jpg'),
                ),
                SizedBox(height: 20),
                Text(
                  '${_user.firstName} ${_user.lastName}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black),
                ),
                SizedBox(height: 10),
                Text(
                  _user.email,
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
                SizedBox(height: 10),
                Text(
                  _user.phone,
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
                SizedBox(height: 10),
                Text(
                  'Student Number: ${_user.studentNumber}',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
                SizedBox(height: 10),
                Text(
                  'Reg Number: ${_user.regNumber}',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfileScreen(
                        user: _user,
                        onSave: _updateUser,
                      )),
                    );
                  },
                  icon: Icon(Icons.edit),
                  label: Text('Edit Profile'),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(Color.fromARGB(255, 3, 142, 27)),
                    foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                    padding: WidgetStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
