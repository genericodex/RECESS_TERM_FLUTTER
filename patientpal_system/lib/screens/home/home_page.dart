import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patientpal_system/screens/appointment/notifications.dart';
//import 'package:ionicons/ionicons.dart';
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
  String? userFirstName;

  @override
  void initState() {
    super.initState();
    _motionTabBarController = MotionTabBarController(
      initialIndex: 1,
      length: 4,
      vsync: this,
    );
    _fetchUserData();
  }

  @override
  void dispose() {
    _motionTabBarController!.dispose();
    super.dispose();
  }

  // To retrieve the user's name in the greeting
  Future<void> _fetchUserData() async {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user;
    if (user != null) {
      final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        userFirstName = userData['firstName'];
      });
    }
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
          //AppointmentReminderPage(),
          
        ],
      ),
    );
  }


Widget _buildHomeContent(String userEmail) {
  return Scaffold(
    backgroundColor: Colors.grey[50],
    appBar: PreferredSize(
      preferredSize: Size.fromHeight(63.0),
      child: AppBar(
        backgroundColor: Colors.grey[50],
        flexibleSpace: FlexibleSpaceBar(
          titlePadding: EdgeInsets.only(left: 19, bottom: 3,),
          title: Align(
            alignment: Alignment.bottomLeft,
            // child: Padding(
            //   padding: const EdgeInsets.all(14.0),
              child: Text(
                'Greetings, ${userFirstName ?? userEmail}!',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Color.fromARGB(255, 22, 4, 56), // Adjust color as needed
                              fontSize: 23, // Adjust size as needed
                              fontWeight: FontWeight.bold,
                            ),
                          ),
              
              ),
            //),
          ),
        ),
      
        // leading: Padding(
        //   padding:const EdgeInsets.only(left: 20.0),
        //   child: Center(
        //     child: Text(
        //             'Greetings!',
        //             style: GoogleFonts.poppins(
        //               textStyle: TextStyle(
        //                 color: Color.fromARGB(255, 22, 4, 56), // Adjust color as needed
        //                 fontSize: 23, // Adjust size as needed
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //     ),
        //   ),            
        // ),
        //title: Center(
          // child: Image.asset(
          //   'assets/icons/iconlogo.png',
          //   height: 30,
          //   color: Color.fromARGB(255, 62, 189, 166),
          //   colorBlendMode: BlendMode.difference
            
          //),
        //),
      ),
    ),
    body: Stack(
      children:[
        // Container(
        //   height: 150,
        //   color: Colors.grey[50],),
      SingleChildScrollView(
        child: Column(
          children: [
            //SizedBox(height: 20),
            // Text(
            //   'Greetings!',
            //   style: GoogleFonts.poppins(
            //     textStyle: TextStyle(
            //       color: Colors.black, // Adjust color as needed
            //       fontSize: 24, // Adjust size as needed
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            //Container(
            //SizedBox(height: 60),
            SizedBox(height: 5),
              //height: 60,
              //color: Colors.blue),
            //      Align(
            //   alignment: Alignment.topLeft,
            //   child: Padding(
            //     padding: const EdgeInsets.only(left: 20.0),
                // child: Text(
                //   'Greetings!',
                //   style: GoogleFonts.poppins(
                //     textStyle: TextStyle(
                //       color: Color.fromARGB(255, 22, 4, 56), // Adjust color as needed
                //       fontSize: 21, // Adjust size as needed
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
            //   ),
            // ),
            SizedBox(height: 5,),
            
            Padding(
              padding: const EdgeInsets.only(left:10.0, right:10.0),
              // child: ClipPath(
              //   clipper: TopBottomCurvedClipper(), // Custom clipper for top and bottom curves
                child: Stack(
                  children: [
                    Container(
                      height: 260, // Adjust the height as needed
                      decoration: BoxDecoration(
                        // border: Border(
                        //   top: BorderSide(
                        //     color: Color.fromARGB(255, 22, 4, 56),
                        //     width: 0.5,
                        //   ),
                        // ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
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
                                SizedBox(height: 10),
                                Text(
                                  ' Welcome to',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Color.fromARGB(255, 241, 255, 251),
                                      letterSpacing: .5,
                                      fontSize: 28,
                                    ),
                                  ),
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
                            width: 100,
                            height: 170,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                    // Positioned.fill(
                    //   child: CustomPaint(
                    //     painter: BorderPainter(),
                    //   ),
                    // ),
                  ],
                ),
              //),
            ),
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.all(12.0),
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
    ]),
  );
}

 


  Widget _buildGridItem(dynamic asset, String title, BuildContext context, Widget page, {Color color = const Color.fromARGB(255, 8, 45, 39), iconcolor = const Color.fromARGB(255, 38, 163, 143)}) {
    return Container(
      //height: 150,
      decoration: BoxDecoration(
        //color: Color.fromARGB(255, 249, 247, 247),
        color: Colors.grey[50],
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
        height: 40,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0.25,
            //backgroundColor: Color.fromARGB(255, 249, 255, 252),
            backgroundColor: Colors.grey[50],
            padding: EdgeInsets.all(11),
            //minimumSize: Size(double.infinity, 50),
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
                fontSize: 15, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 22, 4, 56)
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
