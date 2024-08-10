import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'dart:io';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  User? _user;

  User? get user => _user;
  bool get isLoggedIn => _user != null;
  String? get userEmail => _user?.email;

  Future<void> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      _user = userCredential.user;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> register(String email, String password, String firstName, String lastName, String emergencyNumber) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      _user = userCredential.user;
      if (_user != null) {
        await _firestore.collection('users').doc(_user!.uid).set({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'emergencyNumber': emergencyNumber,
          'profileImageUrl': '',
        });
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
    
  }

Future<DocumentSnapshot> getUserDetails() async {
    if (_user != null) {
      return await _firestore.collection('users').doc(_user!.uid).get();
    } else {
      throw Exception("User not logged in");
    }
  }

Future<void> updateUserDetails(String firstName, String lastName, String emergencyNumber) async {
    if (_user != null) {
      await _firestore.collection('users').doc(_user!.uid).update({
        'firstName': firstName,
        'lastName': lastName,
        'emergencyNumber': emergencyNumber,
      });
      notifyListeners();
    } else {
      throw Exception("User not logged in");
    }
  }
  Future<void> uploadProfileImage(File imageFile) async {
    if (_user != null) {
      try {
        final storageRef = _storage.ref().child('profile_images').child(_user!.uid);
        await storageRef.putFile(imageFile);
        final imageUrl = await storageRef.getDownloadURL();
        await _firestore.collection('users').doc(_user!.uid).update({
          'profileImageUrl': imageUrl,
        });
        notifyListeners();
      } catch (e) {
        print(e);
      }
    } else {
      throw Exception("User not logged in");
    }
  }
}
