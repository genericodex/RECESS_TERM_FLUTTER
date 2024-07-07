import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionBadgeWidget.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import 'pages/appointments_page.dart';
import 'pages/profile_page.dart';
import 'pages/notifications_page.dart';
import 'pages/call_doctor_page.dart';
import 'pages/make_appointment_page.dart';
import 'pages/emergency_page.dart';
import 'pages/feedback_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motion Tab Bar Sample',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  MotionTabBarController? _motionTabBarController;

  int _selectedIndex = 1; // Set initial index to 1 to show HomePage first

  static final List<Widget> _widgetOptions = <Widget>[
    AppointmentsPage(),
    HomePage(),
    ProfilePage(),
    NotificationsPage(), // Add NotificationsPage for the fourth tab
  ];

  @override
  void initState() {
    super.initState();
    _motionTabBarController = MotionTabBarController(
      initialIndex: 1,
      length: 4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _motionTabBarController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Student Care",
          style: TextStyle(color: Color.fromARGB(255, 251, 202, 84)),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 1, 150, 68),
      ),
      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController,
        initialSelectedTab: "Home",
        useSafeArea: true,
        labels: const ["Appointments", "Home", "Profile", "Notifications"],
        icons: const [
          Icons.calendar_today,
          Icons.home,
          Icons.people_alt,
          Icons.notifications
        ],
        tabSize: 50,
        tabBarHeight: 55,
        textStyle: const TextStyle(
          fontSize: 12,
          color: Color.fromARGB(255, 193, 15, 15),
          fontWeight: FontWeight.w500,
        ),
        tabIconColor: Color.fromARGB(255, 198, 192, 188),
        tabIconSize: 28.0,
        tabIconSelectedSize: 26.0,
        tabSelectedColor: Color.fromARGB(255, 1, 150, 68),
        tabIconSelectedColor: Colors.white,
        tabBarColor: Colors.white,
        onTabItemSelected: (int value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello,\nPius Ssozi.',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Welcome to Student Care',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildGridItem(Icons.call, 'Call doctor', context, CallDoctorPage()),
                _buildGridItem(Icons.medication, 'Make Appointment', context, MakeAppointmentPage()),
                _buildGridItem(Icons.emergency, 'Emergency', context, EmergencyPage(), color: Color.fromARGB(255, 193, 15, 15)),
                _buildGridItem(Icons.feedback, 'Feedback', context, FeedbackPage()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(IconData icon, String title, BuildContext context, Widget page, {Color color = Colors.black}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}














