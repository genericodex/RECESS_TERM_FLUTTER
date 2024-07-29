import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:ionicons/ionicons.dart';
import 'package:patientpal_system/screens/appointment/create_appointment_page.dart';
import 'package:patientpal_system/screens/emergency/emergency_location_page.dart';
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
import 'custom_clipper.dart';

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
    final userEmail = authProvider.userEmail ?? 'Guest';

    return Scaffold(
      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController,
        initialSelectedTab: "Home",
        useSafeArea: true,
        labels: const ["My Account", "Home", "Notifications"],
        icons: const [
          FontAwesomeIcons.user,
          FontAwesomeIcons.house,
          FontAwesomeIcons.bell,
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
  return Scaffold(
    backgroundColor: Colors.grey[200],  // Change this to your desired background color
    body: Column(
      children: [
        ClipPath(
          clipper: BottomCurvedClipper(),
          child: Container(
            height: 370,  // Adjust the height as needed
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 128, 235, 215),
                  Color.fromARGB(255, 57, 156, 138),
                ],
              ),
            ),
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 16),
                      Text(
                        'Welcome to',
                        style: TextStyle(
                          fontSize: 28,
                          color: Color.fromARGB(255, 244, 247, 245),
                        ),
                      ),
                      Image.asset(
                        'assets/icons/app_icon2.png',
                        height: 32,
                        color: Color.fromARGB(255, 38, 163, 143),
                        colorBlendMode: BlendMode.difference,
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  'assets/images/vecteezy_realistic-medical-stethoscope-on-transparent-background_16774611.png',
                  width: 140,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ),
        //SizedBox(height: 0),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildGridItem(FontAwesomeIcons.userDoctor, 'Make Appointment', context, BookingPage(), color: Color.fromARGB(255, 38, 163, 143)),
              _buildGridItem('assets/images/ambulance_12618121.png', 'Emergency', context, CenterPage(), color: Color.fromARGB(255, 209, 23, 23)),
              _buildGridItem(FontAwesomeIcons.calendarCheck, 'My Appointments', context, AppointmentsPage(), color: Color.fromARGB(255, 38, 163, 143)),
            ],
          ),
        ),
      ],
    ),
  );
}


  Widget _buildGridItem(dynamic asset, String title, BuildContext context, Widget page, {Color color = const Color.fromARGB(255, 8, 45, 39)}) {
    return Container(
      //height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        height: 150,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 248, 246, 246),
            padding: EdgeInsets.all(16),
            minimumSize: Size(double.infinity, 150),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            
          ),
          onPressed: () {
            if (title == 'Emergency') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CenterPage()),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => page),
              );
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (asset is IconData)
                Icon(asset, size: 50, color: Color.fromARGB(255, 64, 165, 147))
              else if (asset is String && asset.endsWith('.json'))
                Lottie.asset(asset, width: 48, height: 48, frameRate: FrameRate(15))
              else if (asset is String)
                Image.asset(asset, width: 52, height: 52),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
