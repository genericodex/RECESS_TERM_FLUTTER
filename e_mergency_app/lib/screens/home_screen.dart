// import 'package:e_mergency_app/models/appointment.dart';
// import 'package:e_mergency_app/screens/emergency/emergency_history_screen.dart';
import 'package:e_mergency_app/screens/chat/chat_list_screen.dart';
import 'package:e_mergency_app/screens/emergency/emergency_history_screen.dart';
import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'appointments/appointment_list_screen.dart';
// import 'package:motion_tab_bar/MotionBadgeWidget.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
// import 'chat/chat_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  MotionTabBarController? _motionTabBarController;

  int _selectedIndex = 1; // Set initial index to 1 to show HomePage first

  static final List<Widget> _widgetOptions = <Widget>[
    AppointmentsListScreen(),
    HomePage(),
    ProfileScreen(),
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
          style: TextStyle(color: Color.fromARGB(255, 241, 255, 214)),
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
        tabSize: 55,
        tabBarHeight: 55,
        textStyle: const TextStyle(
          fontSize: 13,
          color: Color.fromARGB(255, 15, 96, 2),
          fontWeight: FontWeight.w600,
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
                _buildGridItem(Icons.call, 'Call doctor', color: Color.fromARGB(255, 2, 111, 6),onPressed:() {
                  Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatListScreen()),
            );
                } ),
                _buildGridItem(Icons.medication, 'Make Appointment',color: Color.fromARGB(255, 2, 111, 6),onPressed:() {
                  Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AppointmentsListScreen()),
            );
                },),
                _buildGridItem(Icons.emergency, 'Emergency', color: Color.fromARGB(255, 193, 15, 15), onPressed:() {
                  Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EmergencyHistoryScreen()),
            );
                }),
                _buildGridItem(Icons.feedback, 'Feedback',color: Color.fromARGB(255, 2, 111, 6),onPressed:() {
                  Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatListScreen()),
            );
                } ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(IconData icon, String title, {Color color = Colors.black, required VoidCallback onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: color,),
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


class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Notifications Page'),
    );
  }
}