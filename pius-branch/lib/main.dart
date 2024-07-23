import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'login_package.dart'; 
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import 'pages/appointments_page.dart';
import 'pages/profile_page.dart';
import 'pages/notifications_page.dart';
// import 'pages/call_doctor_page.dart';
import 'pages/make_appointment_page.dart';
import 'pages/emergency_page.dart';
import 'pages/feedback_page.dart';
import 'pages/emergency_sequence/emergency_location_page.dart';
import 'package:line_icons/line_icons.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Care',
      theme: ThemeData(
        primarySwatch: Colors.green,
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor: Color.fromARGB(255, 120, 231, 178)),
        textTheme: TextTheme(
          displaySmall: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 45.0,
            color: Color.fromARGB(255, 120, 231, 178),
          ),
          labelLarge: const TextStyle(
            fontFamily: 'OpenSans',
          ),
          bodySmall: TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
            color: Colors.greenAccent[300],
          ),
          displayLarge: const TextStyle(fontFamily: 'Quicksand'),
          displayMedium: const TextStyle(fontFamily: 'Quicksand'),
          headlineMedium: const TextStyle(fontFamily: 'Quicksand'),
          headlineSmall: const TextStyle(fontFamily: 'NotoSans'),
          titleLarge: const TextStyle(fontFamily: 'NotoSans'),
          titleMedium: const TextStyle(fontFamily: 'NotoSans'),
          bodyLarge: const TextStyle(fontFamily: 'NotoSans'),
          bodyMedium: const TextStyle(fontFamily: 'NotoSans'),
          titleSmall: const TextStyle(fontFamily: 'NotoSans'),
          labelSmall: const TextStyle(fontFamily: 'NotoSans'),
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
            .copyWith(secondary: Color.fromARGB(255, 120, 231, 178)),
      ),
      
      debugShowCheckedModeBanner: false,
      initialRoute: LoginScreen.routeName,
      routes: {LoginScreen.routeName:(context) => const LoginPackage(),
      MyHomePage.routeName:(context) => const MyHomePage()},
       // Set the initial route to the LoginPackage
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;
  static const String routeName = '/home'; // Define a route name

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  MotionTabBarController? _motionTabBarController;

  int _selectedIndex = 1; // Set initial index to 1 to show HomePage first

  static final List<Widget> _widgetOptions = <Widget>[
    AppointmentsPage(),
    HomePage(),
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
          "StudentCARE",
          style: TextStyle(color: Color.fromARGB(255, 233, 240, 239)),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 38, 163, 143),
      ),

      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController,
        initialSelectedTab: "Home",
        useSafeArea: true,
        labels: const ["Appointments", "Home", "My Account"],
        icons: const [
          Ionicons.person_outline,
          LineIcons.home,
          LineIcons.bell,
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
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 243, 237),
      body: Column(
        children: [
          // Container inside AppBar area
          Stack(
            children: [
              Container(
                color: Color.fromARGB(255, 38, 163, 143),
                padding: EdgeInsets.all(16.0),
                height: 280,
                width: double.infinity,
                
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 32), // Space to avoid overlap with status bar
                          Text(
                            'Hello,\nPius Ssozi.',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Welcome to \nStudentCARE',
                            style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 209, 23, 23)),
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
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildGridItem('assets/images/stethoscope_2749779.png', 'Make Appointment', context, MakeAppointmentPage()),
                  _buildGridItem('assets/images/ambulance_12618121.png', 'Emergency', context, EmergencyPage(), color: Color.fromARGB(255, 220, 3, 3)),
                  _buildGridItem('assets/images/icons8-schedule-50.png', 'Appointments Schedule', context, FeedbackPage()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


Widget _buildGridItem(String assetPath, String title, BuildContext context, Widget page, {Color color = const Color.fromARGB(255, 8, 45, 39)}) {
    return Container(
      decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2), // Shadow color
          spreadRadius: 2, // Spread radius
          blurRadius: 4, // Blur radius
          offset: Offset(0, 4), // Offset in x and y directions
        ),
      ],
      borderRadius: BorderRadius.circular(12),
    ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(16),
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
            assetPath.endsWith('.json')
               ?Lottie.asset(assetPath, width: 48, height: 48)
               :Image.asset(assetPath, width: 52, height: 52),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }

