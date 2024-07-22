import 'package:flutter/material.dart';
import 'package:patientpal_system/screens/appointment/create_appointment_page.dart';
import 'package:provider/provider.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import 'package:patientpal_system/providers/auth_provider.dart';
import 'package:line_icons/line_icons.dart';
import 'package:patientpal_system/screens/appointment/appointment_page.dart';
import 'package:patientpal_system/screens/auth/login_page.dart';
// import 'package:patientpal_system/screens/feedback/feedback_page.dart';
import 'package:patientpal_system/screens/emergency/emergency_page.dart';
// import 'package:patientpal_system/screens/make_appointment/make_appointment_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  MotionTabBarController? _motionTabBarController;

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
    final authProvider = context.read<AuthProvider>();
    final userEmail = authProvider.userEmail ?? 'User';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PatientPal',
          style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 24, 176, 123),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(),
      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController,
        initialSelectedTab: "Home",
        useSafeArea: true,
        labels: const ["Appointments", "Home", "Feedback", "Emergency"],
        icons: const [
          Icons.calendar_today,
          Icons.home,
          Icons.feedback,
          Icons.emergency,
        ],
        tabSize: 50,
        tabBarHeight: 55,
        textStyle: const TextStyle(
          fontSize: 12,
          color: Color.fromARGB(255, 38, 163, 143),
          fontWeight: FontWeight.w500,
        ),
        tabIconColor: Color.fromARGB(255, 133, 134, 136),
        tabIconSize: 28.0,
        tabIconSelectedSize: 26.0,
        tabSelectedColor: Color.fromARGB(255, 38, 163, 143),
        tabIconSelectedColor: Colors.white,
        tabBarColor: Colors.white,
        onTabItemSelected: (int value) {
          setState(() {
            _motionTabBarController!.index = value;
          });
        },
      ),
      body: IndexedStack(
        index: _motionTabBarController!.index,
        children: [
          AppointmentsPage(),
          _buildHomeContent(userEmail),
          BookingPage(),
          EmergencyPage(),
        ],
      ),
    );
  }

  Widget _buildHomeContent(String userEmail) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Color.fromARGB(255, 120, 231, 178),
            padding: EdgeInsets.all(16.0),
            height: 280,
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello,\n$userEmail.',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Welcome to \nPatientPal',
                        style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 1, 65, 12)),
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  'assets/images/doctor.jpg',
                  width: 150, // adjust the width as needed
                  height: 220, // adjust the height as needed
                  fit: BoxFit.cover, // adjust the fit as needed
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildGridItem(LineIcons.calendar, 'Make Appointment', context, BookingPage(), color: Color.fromARGB(255, 38, 163, 143)),
                _buildGridItem(LineIcons.ambulance, 'Emergency', context, EmergencyPage(), color: Color.fromARGB(255, 209, 23, 23)),
                _buildGridItem(LineIcons.doctor, 'My Appointments', context, AppointmentsPage(), color: Color.fromARGB(255, 38, 163, 143)),
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
          Icon(icon, size: 48, color: color),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 20, 102, 89)),
          ),
        ],
      ),
    );
  }
}
