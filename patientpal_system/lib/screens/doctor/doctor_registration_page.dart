import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:patientpal_system/providers/doctor_provider.dart';
import 'package:patientpal_system/screens/home/home_page.dart';

class DoctorRegistrationPage extends StatefulWidget {
  @override
  _DoctorRegistrationPageState createState() => _DoctorRegistrationPageState();
}

class _DoctorRegistrationPageState extends State<DoctorRegistrationPage> {
  final _nameController = TextEditingController();
  final _departmentController = TextEditingController();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _startDay;
  String? _endDay;

  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? TimeOfDay.now() : (_startTime ?? TimeOfDay.now()),
    );
    if (picked != null && picked != (isStartTime ? _startTime : _endTime)) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Doctor Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _departmentController,
              decoration: InputDecoration(labelText: 'Department'),
            ),
            ListTile(
              title: Text('Start Time: ${_startTime?.format(context) ?? 'Not set'}'),
              trailing: Icon(Icons.access_time),
              onTap: () => _selectTime(context, true),
            ),
            ListTile(
              title: Text('End Time: ${_endTime?.format(context) ?? 'Not set'}'),
              trailing: Icon(Icons.access_time),
              onTap: () => _selectTime(context, false),
            ),
            DropdownButton<String>(
              hint: Text('Start Day'),
              value: _startDay,
              onChanged: (String? newValue) {
                setState(() {
                  _startDay = newValue;
                });
              },
              items: _days.map<DropdownMenuItem<String>>((String day) {
                return DropdownMenuItem<String>(
                  value: day,
                  child: Text(day),
                );
              }).toList(),
            ),
            DropdownButton<String>(
              hint: Text('End Day'),
              value: _endDay,
              onChanged: (String? newValue) {
                setState(() {
                  _endDay = newValue;
                });
              },
              items: _days.map<DropdownMenuItem<String>>((String day) {
                return DropdownMenuItem<String>(
                  value: day,
                  child: Text(day),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final name = _nameController.text;
                final department = _departmentController.text;
                final workHours = {
                  'start': _startTime?.format(context) ?? 'Not set',
                  'end': _endTime?.format(context) ?? 'Not set'
                };
                final workDays = [_startDay ?? 'Not set', _endDay ?? 'Not set'];

                try {
                  await context.read<DoctorProvider>().registerDoctor(name, department, workHours, workDays);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                } catch (e) {
                  print(e.toString());
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Registration failed: ${e.toString()}'))
                  );
                }
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
