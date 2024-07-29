import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'current_location_page.dart';
import 'package:location/location.dart';



class CenterPage extends StatefulWidget {
  @override
  _CenterPageState createState() => _CenterPageState();
}

class _CenterPageState extends State<CenterPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Location location = new Location();
  LocationData? _currentLocation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _getCurrentLocation();
  }

  

  void _getCurrentLocation() async {
    LocationData _locationData = await location.getLocation();
    setState(() {
      _currentLocation = _locationData;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();

  }

 

  // final googleMapsLink =
  //       'https://www.google.com/maps/dir/?api=1&origin=${_currentLocation!.latitude},${_currentLocation!.longitude}&travelmode=driving';


  Future<void> _onSOSPressed() async {
    if (_currentLocation != null) {
    } else {
      
      print("Location is not available.");
    }

    final googleMapsLink =
        'https://www.google.com/maps/search/?api=1&query=${_currentLocation!.latitude},${_currentLocation!.longitude}';



    if (await Permission.sms.isGranted) {
      smsFunction(message: 'Emergency reported! Please send help to the location: $googleMapsLink', number: '+256 705 642691');
    } else {
      final status = await Permission.sms.request();
      if (status.isGranted) {
        smsFunction(message: 'Emergency reported! Please send help to the location: $googleMapsLink', number: '+256 705 642691');
      }
    }
    // Send the SMS
    //sendSMS('+256 702 613426', 'This is an emergency! Please send help to my location.');
    // Implement the SOS button functionality here
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LocationScreen()),
    );

    
  }

  Future<void> smsFunction({required String message, required String number}) async {
    SmsStatus res = await BackgroundSms.sendMessage(
      phoneNumber: number,
      message: message,
    );
    // Handle SMS status if needed
    if (res == SmsStatus.sent) {
      print("SMS sent successfully");
    } else {
      print("Failed to send SMS");
    }
  }

  //void sendSMS(String phoneNumber, String message) async {
    //final Uri uri = Uri(
      //scheme: 'sms',
      //path: phoneNumber,
      //queryParameters: <String, String>{
        //'body': message,
      //},
    //);

    //if (await canLaunchUrl(uri.toString() as Uri)) {
      //await launchUrl(uri.toString() as Uri);
    //} else {
      //throw 'Could not launch $uri';
    //}
  //}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onLongPress: _onSOSPressed,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _animation.value,
                    child: child,
                  );
                },
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 200, 14, 14),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withOpacity(0.6),
                        spreadRadius: 10,
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'SOS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Press for 3 seconds',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 20),
            Text(
              '\nKEEP CALM!\nAfter pressing SOS button we will have an ambulance at your location.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}