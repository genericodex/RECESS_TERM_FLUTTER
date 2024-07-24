import 'package:flutter/material.dart';
import 'current_location_page.dart';


class CenterPage extends StatefulWidget {
  @override
  _CenterPageState createState() => _CenterPageState();
}

class _CenterPageState extends State<CenterPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSOSPressed() {
    // Implement the SOS button functionality here
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LocationScreen()),
    );
  }

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
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pinkAccent.withOpacity(0.6),
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
                            fontSize: 40,
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
