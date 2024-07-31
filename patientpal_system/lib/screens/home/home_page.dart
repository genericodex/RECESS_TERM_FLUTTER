import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patientpal_system/screens/appointment/notifications.dart';
import 'package:ionicons/ionicons.dart';
import 'package:patientpal_system/screens/appointment/create_appointment_page.dart';
import 'package:patientpal_system/screens/auth/profile_page.dart';
import 'package:patientpal_system/screens/doctor/doctor_registration_page.dart';
import 'package:patientpal_system/screens/emergency/emergency_location_page.dart';
import 'package:provider/provider.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import 'package:patientpal_system/providers/auth_provider.dart';
import 'package:patientpal_system/screens/appointment/appointment_page.dart';
import 'clipper.dart';

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
        labels: const ["My Profile", "Home", "Notifications"],
        icons: const [
          FontAwesomeIcons.user,
          FontAwesomeIcons.house,
          FontAwesomeIcons.bell,
        ],
        tabSize: 50,
        tabBarHeight: 52,
        textStyle: const TextStyle(
          fontSize: 12,
          color: Color.fromARGB(255, 38, 163, 143),
          fontWeight: FontWeight.w500,
        ),
        tabIconColor: Color.fromARGB(255, 133, 134, 136),
        tabIconSize: 25.0,
        tabIconSelectedSize: 26.0,
        tabSelectedColor: Color.fromARGB(255, 38, 163, 143),
        tabIconSelectedColor: Colors.grey[50],
        tabBarColor: Color.fromARGB(255, 249, 255, 252),
        onTabItemSelected: (int value) {
          setState(() {
            _motionTabBarController!.index = value;
          });
        },
      ),
      body: IndexedStack(
        index: _motionTabBarController!.index,
        children: [
          ProfilePage(),
          _buildHomeContent(userEmail),
          NotificationsPage(),
          
        ],
      ),
    );
  }


Widget _buildHomeContent(String userEmail) {
  return Scaffold(
    backgroundColor: Colors.grey[50],
    body: SingleChildScrollView(
      child: Column(
        children: [
          ClipPath(
            clipper: BottomCurvedClipper(),
            child: Stack(
              children: [Container(
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
                            ' Welcome to',
                            style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color:  Color.fromARGB(255, 241, 255, 251),
                              letterSpacing: .5,
                              fontSize: 28,
                              )
                            )
                          ),
                          Image.asset(
                            'assets/icons/app_icon2.png',
                            height: 32,
                            color: Color.fromARGB(255, 69, 185, 163),
                            colorBlendMode: BlendMode.difference,
                            fit: BoxFit.fill,
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      'assets/images/main_page_img.png',
                      width: 140,
                      height: 220,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                  child: CustomPaint(
                    painter: BorderPainter(),
                  ),
                ),
        ]),
          
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
                _buildGridItem('assets/images/emergency.png', 'Emergency', context, CenterPage(), color: Color.fromARGB(255, 209, 23, 23), iconcolor: Color.fromARGB(255, 209, 23, 23)),
                _buildGridItem(FontAwesomeIcons.calendarCheck, 'My Appointments', context, AppointmentsPage(), color: Color.fromARGB(255, 38, 163, 143)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

 


  Widget _buildGridItem(dynamic asset, String title, BuildContext context, Widget page, {Color color = const Color.fromARGB(255, 8, 45, 39), iconcolor = const Color.fromARGB(255, 38, 163, 143)}) {
    return Container(
      //height: 150,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 249, 247, 247),
        border: Border.all(color: Color.fromARGB(255, 2, 107, 77), width: .5),
        boxShadow: [
          // BoxShadow(
          //   color: Color.fromARGB(255, 6, 47, 67).withOpacity(0.2),
          //   spreadRadius: 1,
          //   blurRadius: 1,
          //   offset: Offset(0, 1),
          // ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0.25,
            backgroundColor: Color.fromARGB(255, 249, 255, 252),
            padding: EdgeInsets.all(11),
            minimumSize: Size(double.infinity, 50),
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
                Icon(asset, size: 44, color: iconcolor)
              else if (asset is String && asset.endsWith('.json'))
                Lottie.asset(asset, width: 48, height: 48, frameRate: FrameRate(15))
              else if (asset is String)
                Image.asset(asset, width: 52, height: 52),
              SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.cairo(
              textStyle: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: color
                )
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
