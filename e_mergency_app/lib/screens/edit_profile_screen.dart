import 'package:flutter/material.dart';
import '../models/user.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;
  final Function(User) onSave;

  EditProfileScreen({required this.user, required this.onSave});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _firstName;
  late String _lastName;
  late String _email;
  late String _phone;
  late String _studentNumber;
  late String _regNumber;

  @override
  void initState() {
    super.initState();
    _firstName = widget.user.firstName;
    _lastName = widget.user.lastName;
    _email = widget.user.email;
    _phone = widget.user.phone;
    _studentNumber = widget.user.studentNumber;
    _regNumber = widget.user.regNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  initialValue: _firstName,
                  decoration: InputDecoration(labelText: 'First Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _firstName = value!;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: _lastName,
                  decoration: InputDecoration(labelText: 'Last Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _lastName = value!;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: _email,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value!;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: _phone,
                  decoration: InputDecoration(labelText: 'Phone'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _phone = value!;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: _studentNumber,
                  decoration: InputDecoration(labelText: 'Student Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your student number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _studentNumber = value!;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: _regNumber,
                  decoration: InputDecoration(labelText: 'Registration Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your registration number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _regNumber = value!;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      widget.onSave(User(
                        // id: widget.user.id,
                        firstName: _firstName,
                        lastName: _lastName,
                        email: _email,
                        phone: _phone,
                        studentNumber: _studentNumber,
                        regNumber: _regNumber,
                      ));
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
