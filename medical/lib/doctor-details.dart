// import 'package:flutter/material.dart';
// import 'package:medical/custom-appbar.dart';
// //import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class DoctorDetails extends StatefulWidget {
//   // const DoctorDetails({super.key, required Map<String, dynamic> schedule});

//   @override
//   State<DoctorDetails> createState() => _DoctorDetailsState();
// }

// class _DoctorDetailsState extends State<DoctorDetails> {
//   bool isFav = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("DoctorDetails"),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               setState(() {
//                 isFav = !isFav;
//               });
//             },
//             icon: Icon(
//               isFav ? Icons.favorite : Icons.favorite_border,
//               color: Colors.red,
//             ),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Column(
//           children: <Widget>[],
//         ),
//       ),
//     );
//   }
// }

//  class Config {
//   static late double spaceMedium;

//   void init(BuildContext context) {
//     spaceMedium = MediaQuery.of(context).size.height * 0.02;
//   }
// }

// class AboutDoctor extends StatelessWidget {
//   const AboutDoctor({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Config().init(context);
//     return Container(
//       width: double.infinity,
//       child: Column(
//         children: [
//           const CircleAvatar(
//             radius: 65.0,
//             backgroundImage: AssetImage('assets/chemist.jpg'),
//             backgroundColor: Colors.white,
//           ),
//         SizedBox(height:Config.spaceMedium),
          
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DoctorDetailsPage extends StatefulWidget {
  @override
  _DoctorDetailsPageState createState() => _DoctorDetailsPageState();
}

class _DoctorDetailsPageState extends State<DoctorDetailsPage> {
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;
  bool _isWeekend = false;
  bool _dateSelected = false;
  bool _timeSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Details & Booking'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Details Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dr. John Doe',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Cardiologist',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Biography',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Dr. John Doe is a renowned cardiologist with over 20 years of experience. He specializes in heart-related treatments and surgeries.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Contact Information',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Phone: +1234567890\nEmail: johndoe@example.com',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Divider(),
            // Booking Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Book an Appointment',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusDay,
                    calendarFormat: _format,
                    selectedDayPredicate: (day) => isSameDay(_currentDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _currentDay = selectedDay;
                        _focusDay = focusedDay;
                        _dateSelected = true;
                        _isWeekend = selectedDay.weekday == DateTime.saturday || selectedDay.weekday == DateTime.sunday;
                      });
                    },
                    onFormatChanged: (format) {
                      setState(() {
                        _format = format;
                      });
                    },
                    calendarStyle: CalendarStyle(
                      isTodayHighlighted: true,
                      selectedDecoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  if (_dateSelected) ...[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Selected Date: ${_currentDay.toLocal()}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    _isWeekend
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Weekend is not available for booking.',
                              style: TextStyle(fontSize: 18, color: Colors.red),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 10, // Number of available time slots
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text('Time Slot ${index + 1}'),
                                onTap: () {
                                  setState(() {
                                    _currentIndex = index;
                                    _timeSelected = true;
                                  });
                                },
                                selected: _currentIndex == index,
                              );
                            },
                          ),
                  ],
                  if (_dateSelected && _timeSelected)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Implement booking logic here
                        },
                        child: Text('Book Now'),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
