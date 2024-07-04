import 'package:flutter/material.dart';
import '../../models/user.dart';

class ProfileProvider with ChangeNotifier {
  User _user = User(firstName: 'John',
                     lastName: 'Doe', 
                     email: 'john.doe@example.com', 
                     phone: '123-456-7890', 
                     studentNumber: '', 
                     regNumber: '',
                     );

  User get user => _user;

  void updateUser(String firstName, String email, String phone, String lastName, String studentNumber, String regNumber,) {
    _user = User(firstName: firstName, 
                  lastName: lastName,
                  email: email, 
                  phone: phone, 
                  studentNumber: studentNumber,
                  regNumber: regNumber,
                  );
    notifyListeners();
  }
}
