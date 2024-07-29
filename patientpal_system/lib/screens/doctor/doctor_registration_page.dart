import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:patientpal_system/main.dart';
import 'package:uuid/uuid.dart';
import 'package:patientpal_system/screens/home/home_page.dart';


class CustomChoiceChip extends StatelessWidget {
  final String day;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const CustomChoiceChip({
    Key? key,
    required this.day,
    required this.isSelected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(
        day,
        style: TextStyle(
          color: isSelected ? Colors.white : Color(0xFF264653),
          fontWeight: FontWeight.bold,
        ),
      ),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: Color(0xFF2A9D8F),
      backgroundColor: Color.fromARGB(255, 151, 250, 225).withOpacity(0.2),
      avatar: isSelected
          ? Icon(Icons.check, color: Colors.white)
          : Icon(Icons.circle, color: Color.fromARGB(255, 3, 167, 140).withOpacity(0.5)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isSelected ? Color.fromARGB(255, 16, 158, 141) : Color.fromARGB(255, 38, 83, 78).withOpacity(0.5),
          width: 2,
        ),
      ),
      // elevation: 3,
      pressElevation: 5,
    );
  }
}

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
        backgroundColor: Color(0xFF2A9D8F),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_nameController, 'Name', Icons.person),
              _buildTextField(_departmentController, 'Department', Icons.business),
              _buildTextField(_startHourController, 'Start Hour (HH:mm)', Icons.access_time),
              _buildTextField(_endHourController, 'End Hour (HH:mm)', Icons.access_time),
              SizedBox(height: 20),
              Text('Select Working Days:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8.0,
                children: _daysOfWeek.map((day) {
                  return CustomChoiceChip(
                    day: day,
                    isSelected: _selectedDays.contains(day),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF264653),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('Register Doctor', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Color(0xFF264653)),
          prefixIcon: Icon(icon, color: Color(0xFF264653)),
          filled: true,
          fillColor: Color.fromARGB(255, 97, 244, 202).withOpacity(0.1),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Color(0xFF264653)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Color(0xFF2A9D8F)),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the $labelText';
          }
          return null;
        },
      ),
    );
  }
}
