import 'package:flutter/material.dart';

class DrawingArea {
  Offset point;
  Paint areaPaint;

  DrawingArea({required this.point, required this.areaPaint});

  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DrawingArea &&
        other.point == point &&
        other.areaPaint.color == areaPaint.color &&
        other.areaPaint.strokeWidth == areaPaint.strokeWidth;
  }

  @override
  int get hashCode =>
      point.hashCode ^
      areaPaint.color.hashCode ^
      areaPaint.strokeWidth.hashCode;
}
