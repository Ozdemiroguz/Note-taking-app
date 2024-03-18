import 'dart:ui';

import 'package:flutter/material.dart';
import 'drawing_area.dart';

class MyCustomPainter extends CustomPainter {
  List<DrawingArea> points;
  Color backgroundColor;

  MyCustomPainter({required this.points, required this.backgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    Paint background = Paint()..color = backgroundColor;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);
    canvas.clipRect(rect);

    for (int x = 0; x < points.length - 1; x++) {
      if (points[x + 1] != null) {
        Paint paint = points[x].areaPaint;
        canvas.drawLine(points[x].point, points[x + 1].point, paint);
      } else if (points[x + 1] == null) {
        Paint paint = points[x].areaPaint;
        canvas.drawPoints(PointMode.points, [points[x].point], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
