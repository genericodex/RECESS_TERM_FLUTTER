import 'package:flutter/material.dart';

class BottomCurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color.fromARGB(255, 3, 50, 41)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0;

    Path path = Path();
    path.moveTo(0, size.height - 40);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 40);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class TopBottomCurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double curveHeight = 20.0;

    // Top curve
    path.lineTo(0, curveHeight);
    path.lineTo(size.width, curveHeight);
    //path.quadraticBezierTo(
        //size.width / 2, 0, size.width, curveHeight);

    // Bottom curve
    path.lineTo(size.width, size.height - curveHeight);
    path.lineTo(0, size.height - curveHeight);
    //path.quadraticBezierTo(
        //size.width / 2, size.height, 0, size.height - curveHeight);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}