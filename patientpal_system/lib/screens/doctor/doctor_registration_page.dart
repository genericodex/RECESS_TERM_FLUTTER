import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:patientpal_system/main.dart';
import 'package:uuid/uuid.dart';

class DoctorRegistrationPage extends StatefulWidget {
  @override
  _DoctorRegistrationPageState createState() => _DoctorRegistrationPageState();
}

class _DoctorRegistrationPageState extends State<DoctorRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _startHourController = TextEditingController();
  final TextEditingController _endHourController = TextEditingController();
  List<String> _selectedDays = [];

  final List<String> _daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  void _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedDays.isNotEmpty) {
      String uid = Uuid().v4();

      await FirebaseFirestore.instance.collection('doctors').doc(uid).set({
        'name': _nameController.text,
        'department': _departmentController.text,
        'uid': uid,
        'working_days': _selectedDays,
        'working_hours': {
          'start': _startHourController.text,
          'end': _endHourController.text,
        },
      });


      for (String day in _selectedDays) {
        await generateDailyTimeSlots(
          FirebaseFirestore.instance,
          uid,
          day,
          _startHourController.text,
          _endHourController.text,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Doctor registered successfully!')),
      );

      _nameController.clear();
      _departmentController.clear();
      _startHourController.clear();
      _endHourController.clear();
      setState(() {
        _selectedDays.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Doctor'),
        backgroundColor: Color.fromARGB(255, 24, 176, 123),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the doctor\'s name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _departmentController,
                decoration: InputDecoration(labelText: 'Department'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the department';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _startHourController,
                decoration: InputDecoration(labelText: 'Start Hour (HH:mm)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the start hour';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _endHourController,
                decoration: InputDecoration(labelText: 'End Hour (HH:mm)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the end hour';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text('Select Working Days:'),
              Wrap(
                children: _daysOfWeek.map((day) {
                  return ChoiceChip(
                    label: Text(day),
                    selected: _selectedDays.contains(day),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedDays.add(day);
                        } else {
                          _selectedDays.remove(day);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Register Doctor'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
