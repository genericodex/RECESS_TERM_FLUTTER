import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  String _email = '';
  String _password = '';
  String _firstName = '';
  String _lastName = '';
  String _studentNumber = '';
  String _regNumber = '';
  String _phoneNumber = '';
  User? _user;

  String get email => _email;
  set email(String value) {
    _email = value;
    notifyListeners();
  }

  String get password => _password;
  set password(String value) {
    _password = value;
    notifyListeners();
  }

  String get firstName => _firstName;
  set firstName(String value) {
    _firstName = value;
    notifyListeners();
  }

  String get lastName => _lastName;
  set lastName(String value) {
    _lastName = value;
    notifyListeners();
  }

  String get studentNumber => _studentNumber;
  set studentNumber(String value) {
    _studentNumber = value;
    notifyListeners();
  }

  String get regNumber => _regNumber;
  set regNumber(String value) {
    _regNumber = value;
    notifyListeners();
  }

  String get phoneNumber => _phoneNumber;
  set phoneNumber(String value) {
    _phoneNumber = value;
    notifyListeners();
  }

  User? get user => _user;

  void login() {
    _user = User(
      
      firstName: _firstName,
      lastName: _lastName,
      studentNumber: _studentNumber,
      regNumber: _regNumber,
      phone: _phoneNumber,
      email: _email,
    );
    notifyListeners();
  }

  void signup() {
    _user = User(
      
      firstName: _firstName,
      lastName: _lastName,
      studentNumber: _studentNumber,
      regNumber: _regNumber,
      phone: _phoneNumber,
      email: _email,
    );
    notifyListeners();
  }

  void updateProfile() {
    _user = User(
      firstName: _firstName,
      lastName: _lastName,
      studentNumber: _studentNumber,
      regNumber: _regNumber,
      phone: _phoneNumber,
      email: _email,
    );
    notifyListeners();
  }
}
