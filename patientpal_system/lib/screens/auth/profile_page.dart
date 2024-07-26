import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User _user;
  String? _firstName, _lastName, _phoneNumber, _profilePicUrl;
  File? _profilePic;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(_user.uid).get();
    if (doc.exists) {
      setState(() {
        _firstName = doc['firstName'];
        _lastName = doc['lastName'];
        _phoneNumber = doc['phoneNumber'];
        _profilePicUrl = doc['profilePicUrl'];
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Map<String, dynamic> profileData = {
        'firstName': _firstName,
        'lastName': _lastName,
        'phoneNumber': _phoneNumber,
        'profilePicUrl': _profilePicUrl,
      };

      await _firestore.collection('users').doc(_user.uid).set(profileData, SetOptions(merge: true));

      // Show confirmation message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated')));
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profilePic = File(pickedFile.path);
      });

      // Here you would upload the image to Firebase Storage and get the URL to save in Firestore
      // For demonstration, just setting a placeholder URL
      setState(() {
        _profilePicUrl = 'https://example.com/profile-pic-url'; // Replace with actual URL
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _profilePic != null
                        ? FileImage(_profilePic!)
                        : _profilePicUrl != null
                            ? NetworkImage(_profilePicUrl!) as ImageProvider
                            : AssetImage('assets/images/default.jpeg'), // Replace with your default profile pic asset
                    child: _profilePic == null && _profilePicUrl == null
                        ? Icon(Icons.camera_alt, size: 50, color: Colors.grey[700])
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: _firstName,
                decoration: InputDecoration(labelText: 'First Name'),
                onSaved: (value) => _firstName = value,
                validator: (value) => value!.isEmpty ? 'Please enter your first name' : null,
              ),
              TextFormField(
                initialValue: _lastName,
                decoration: InputDecoration(labelText: 'Last Name'),
                onSaved: (value) => _lastName = value,
                validator: (value) => value!.isEmpty ? 'Please enter your last name' : null,
              ),
              TextFormField(
                initialValue: _phoneNumber,
                decoration: InputDecoration(labelText: 'Phone Number'),
                onSaved: (value) => _phoneNumber = value,
                validator: (value) => value!.isEmpty ? 'Please enter your phone number' : null,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _updateProfile,
                child: Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
