import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patientpal_system/screens/home/home_page.dart';
import 'package:provider/provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:patientpal_system/providers/auth_provider.dart';


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null) {
      final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userData.exists) {
        final data = userData.data()!;
        _firstNameController.text = data['firstName'] ?? '';
        _lastNameController.text = data['lastName'] ?? '';
        _phoneController.text = data['emergencyNumber'] ?? '';
        _emailController.text = data['email'] ?? '';
        setState(() {
          _image = data['profileImageUrl'] != null ? File(data['profileImageUrl']) : null;
        });
      }
    }
  }

  Future<void> _updateUserData() async {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'emergencyNumber': _phoneController.text,
        'email': _emailController.text,
        'profileImageUrl': _image?.path,
      },SetOptions(merge: true));
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (Route<dynamic> route) => false,
            );
          },
        ),
        title: Text(
          'My Profile',
          style: GoogleFonts.poppins(textStyle: const TextStyle(color: Colors.white, letterSpacing: .5)),
        ),
        backgroundColor: const Color.fromARGB(255, 24, 176, 151),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              // color: Colors.grey[50],
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 255, 255, 255), Color.fromARGB(255, 215, 255, 245)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: _image != null
                              ? FileImage(_image!)
                              : const AssetImage('assets/images/default.jpeg') as ImageProvider,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt, color: Colors.grey),
                            onPressed: _pickImage,
                            color: const Color.fromARGB(255, 33, 243, 170),
                            iconSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 300,
                    child: TextField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        labelStyle: const TextStyle(color: Colors.black),
                        prefixIcon: const Icon(Icons.person, color: Colors.black),
                        filled: true,
                        fillColor: Color.fromARGB(255, 112, 255, 210).withOpacity(0.2),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Color.fromARGB(255, 1, 59, 47)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Color.fromARGB(255, 5, 172, 138)),
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 300,
                    child: TextField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        labelStyle: const TextStyle(color: Colors.black),
                        prefixIcon: const Icon(Icons.person, color: Colors.black),
                        filled: true,
                        fillColor: Color.fromARGB(255, 112, 255, 210).withOpacity(0.2),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Color.fromARGB(255, 5, 172, 138)),
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 300,
                    child: TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Emergency Number',
                        labelStyle: const TextStyle(color: Colors.black),
                        prefixIcon: const Icon(Icons.phone, color: Colors.black),
                        filled: true,
                        fillColor: Color.fromARGB(255, 112, 255, 210).withOpacity(0.2),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Color.fromARGB(255, 5, 172, 138)),
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: 300,
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.black),
                        prefixIcon: const Icon(Icons.phone, color: Colors.black),
                        filled: true,
                        fillColor: Color.fromARGB(255, 112, 255, 210).withOpacity(0.2),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Color.fromARGB(255, 5, 172, 138)),
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _updateUserData,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, 
                      backgroundColor: const Color.fromARGB(255, 57, 156, 138),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Update Profile',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
