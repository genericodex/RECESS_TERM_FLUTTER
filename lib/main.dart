import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: AppointmentPage(),
      ),
    );
  }
}

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

enum FliterStatus { upcoming, complete, cancel }

class _AppointmentPageState extends State<AppointmentPage> {
  FliterStatus status = FliterStatus.upcoming;
  Alignment _alignment = Alignment.centerLeft;
  List<dynamic> schedules = [
    {
      'doctor_name': "Richard Tan",
      'doctor_profile': "assets/dentist.jpg",
      'category': "Dental",
      'status': "FliterStatus.upcoming",
    },
    {
      'doctor_name': "Ruth",
      'doctor_profile': "assets/nurse.jpg",
      'category': "Nurse",
      'status': "FliterStatus.Complete",
    },
    {
      'doctor_name': "Micheal",
      'doctor_profile': "assets/doc.jpg",
      'category': "Doctor",
      'status': "FliterStatus.Complete",
    },
    {
      'doctor_name': "Nara",
      'doctor_profile': "assets/chemist.jpg",
      'category': "Chemist",
      'status': "FliterStatus.upcoming",
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<dynamic> fliterSchedules = schedules.where((var schedule) {
      // switch(schedule['status']){
      //   case'upcoming':
      //     schedule['status'] = FliterStatus.upcoming;
      //     break;
      //   case 'complete':
      //     schedule['status'] = FliterStatus.complete;
      //     break;
      //   case "cancel":
      //   schedule['status'] = FliterStatus.cancel;
      //   break;
      // }
      return schedule['status'] == status;
    }).toList();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Appointment Schedule',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (FliterStatus fliterStatus in FliterStatus.values)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (fliterStatus == FliterStatus.upcoming) {
                                  status = FliterStatus.upcoming;
                                  _alignment = Alignment.centerLeft;
                                } else if (fliterStatus ==
                                    FliterStatus.complete) {
                                  status = FliterStatus.complete;
                                  _alignment = Alignment.center;
                                } else if (fliterStatus ==
                                    FliterStatus.cancel) {
                                  status = FliterStatus.cancel;
                                  _alignment = Alignment.centerRight;
                                }
                              });
                            },
                            child: Center(
                              child: Text(fliterStatus.name),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                AnimatedAlign(
                  alignment: _alignment,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        status.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Config.spaceSmall,
            Expanded(
              child: ListView.builder(
                itemCount: fliteredSchedules.length,
                itemBuilder: ((context, index) {
                  var_schedule = fliteredSchedules[index];git 
