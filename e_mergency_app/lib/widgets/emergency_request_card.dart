import 'package:flutter/material.dart';
import '../models/emergency_request.dart';

class EmergencyRequestCard extends StatelessWidget {
  final EmergencyRequest request;

  EmergencyRequestCard({required this.request});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Request ID: ${request.id}'),
        subtitle: Text('Status: ${request.status}'),
      ),
    );
  }
}
