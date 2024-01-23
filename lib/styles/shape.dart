import 'package:flutter/material.dart';

class TopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height); // Sol alt köşe
    path.lineTo(size.width, size.height); // Sağ alt köşe
    path.lineTo(size.width, 30); // Sağ üst köşe
    path.quadraticBezierTo(size.width / 2, 0, 0, 30); // Orta üst köşe
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class BottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0); // Sol üst köşe
    path.quadraticBezierTo(
        size.width / 2, -size.height, size.width, 0); // Orta alt köşe
    path.lineTo(size.width, size.height); // Sağ alt köşe
    path.lineTo(0, size.height); // Sol alt köşe
    return path;
  }

  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
