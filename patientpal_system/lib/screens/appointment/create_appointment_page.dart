import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:patientpal_system/providers/appointment_provider.dart';
import 'package:patientpal_system/providers/auth_provider.dart';

class CreateAppointmentPage extends StatefulWidget {
  @override
  _CreateAppointmentPageState createState() => _CreateAppointmentPageState();
}

class _CreateAppointmentPageState extends State<CreateAppointmentPage> {
  final _ailmentTypeController = TextEditingController();
  DateTime? _appointmentDate;
  TimeOfDay? _appointmentTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _appointmentDate) {
      setState(() {
        _appointmentDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _appointmentTime) {
      setState(() {
        _appointmentTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Appointment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _ailmentTypeController,
              decoration: InputDecoration(labelText: 'Ailment Type'),
            ),
            ListTile(
              title: Text('Appointment Date: ${_appointmentDate != null ? _appointmentDate!.toLocal().toString().split(' ')[0] : 'Not set'}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            ListTile(
              title: Text('Appointment Time: ${_appointmentTime != null ? _appointmentTime!.format(context) : 'Not set'}'),
              trailing: Icon(Icons.access_time),
              onTap: () => _selectTime(context),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final ailmentType = _ailmentTypeController.text;
                if (_appointmentDate != null && _appointmentTime != null) {
                  final dateTime = DateTime(
                    _appointmentDate!.year,
                    _appointmentDate!.month,
                    _appointmentDate!.day,
                    _appointmentTime!.hour,
                    _appointmentTime!.minute,
                  );

                  try {
                    final user = context.read<AuthProvider>().user;
                    if (user != null) {
                      await context.read<AppointmentProvider>().createAppointment(
                        user.uid,
                        ailmentType,
                        dateTime,
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please log in to create an appointment'), backgroundColor: Colors.red),
                      );
                    }
                  } catch (e) {
                    print(e.toString());
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Appointment creation failed: ${e.toString()}'), backgroundColor: Colors.red),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select date and time'), backgroundColor: Colors.red),
                  );
                }
              },
              child: Text('Create Appointment'),
            ),
          ],
        ),
      ),
    );
  }
}
