import 'package:flutter/material.dart';
import '../models/emergency_request.dart';
import 'package:uuid/uuid.dart';

class EmergencyProvider with ChangeNotifier {
  List<EmergencyRequest> _history = [];

  List<EmergencyRequest> get history => _history;

  void sendEmergencyRequest() {
    final request = EmergencyRequest(
      id: Uuid().v4(),
      status: 'Pending',
    );
    _history.add(request);
    notifyListeners();
  }
}
