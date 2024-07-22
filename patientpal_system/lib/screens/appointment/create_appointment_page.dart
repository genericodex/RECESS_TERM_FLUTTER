import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:patientpal_system/providers/appointment_provider.dart';
import 'package:patientpal_system/providers/auth_provider.dart';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedAilment;

  final List<String> _ailmentOptions = [
    'Optics',
    'Dental',
    'General',
    'ENT',
    // Add more ailment types as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book an Appointment'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        // backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Date and Time',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text(
                _selectedDate == null
                    ? 'Select Date'
                    : 'Date: ${DateFormat.yMMMd().format(_selectedDate!)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 7, 151, 57),
                ),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.teal, // Text color
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                elevation: 5, // Shadow
                shadowColor: Colors.black.withOpacity(0.3), // Shadow color
              ).copyWith(
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.pressed)) {
                      return Color.fromARGB(255, 0, 121, 65); // Darker color when pressed
                    }
                    return Color.fromARGB(255, 202, 251, 221); // Default color
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _selectTime(context),
              child: Text(
                _selectedTime == null
                    ? 'Select Time'
                    : 'Time: ${_selectedTime!.format(context)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 7, 151, 57),
                ),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Color.fromARGB(255, 2, 145, 54),
                backgroundColor: Color.fromARGB(255, 194, 255, 220), // Text color
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                elevation: 5, // Shadow
                shadowColor: Colors.black.withOpacity(0.3), // Shadow color
              ).copyWith(
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.pressed)) {
                      return const Color.fromARGB(255, 0, 121, 65); // Darker color when pressed
                    }
                    return Color.fromARGB(255, 202, 251, 221); // Default color
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
            value: _selectedAilment,
            hint: Text(
              'Select Ailment',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            items: _ailmentOptions.map((ailment) {
              return DropdownMenuItem<String>(
                value: ailment,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    ailment,
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedAilment = newValue;
              });
            },
            dropdownColor: const Color.fromARGB(255, 209, 231, 229), // Background color of the dropdown
            iconEnabledColor: Colors.teal, // Color of the dropdown icon
            style: TextStyle(
              color: Colors.teal, // Color of the selected item text
              fontSize: 16,
            ),
            underline: Container(
              height: 1.5,
              color: const Color.fromARGB(255, 0, 150, 80), // Underline color
            ),
            isExpanded: true, // Makes the dropdown button full width
          ),
            SizedBox(height: 24),
            ElevatedButton(
  onPressed: _bookAppointment,
  child: Text(
    'Book Now',
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),
  style: ElevatedButton.styleFrom(
    foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 0, 150, 77), // Text color
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12), // Rounded corners
    ),
    elevation: 5, // Shadow
    shadowColor: Colors.black.withOpacity(0.3), // Shadow color
  ).copyWith(
    backgroundColor: WidgetStateProperty.resolveWith<Color>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.pressed)) {
          return const Color.fromARGB(255, 0, 121, 44); // Darker color when pressed
        }
        return const Color.fromARGB(255, 0, 150, 80); // Default color
      },
    ),
  ),
),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _bookAppointment() async {
  final user = context.read<AuthProvider>().user;
  if (user != null && _selectedDate != null && _selectedTime != null && _selectedAilment != null) {
    try {
      DateTime dateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
      await context.read<AppointmentProvider>().createAppointment(
        user.uid,
        _selectedAilment!,
        dateTime,
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Appointment booked successfully'),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to book appointment: $e'),
        backgroundColor: Colors.red,
      ));
      print('Failed to book appointment: $e');
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Please complete all fields'),
      backgroundColor: Colors.red,
    ));
    print('Please complete all fields');
  }
}


}

extension DateTimeFormatting on DateTime {
  String toShortDateString() {
    return '${this.day}-${this.month}-${this.year}';
  }
}
