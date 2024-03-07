import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFFDCF2F1);
  static const Color darkBack = Color.fromRGBO(19, 23, 66, 1);
  static const Color accentColor = Color(0xFF08A8FB);
  static const Color softBack = Color(0xFF3552B3);
  static const kCanvasColor = Color(0xfff2f3f7);
  // ... istediğiniz kadar renk ekleyebilirsiniz.
}

Color getcolor(colorNumber) {
  switch (colorNumber) {
    case 1:
      return Colors.white.withOpacity(0.5);
    case 2:
      return Colors.red.withOpacity(0.5);
    case 3:
      return Colors.yellow.withOpacity(0.5);
    case 4:
      return Colors.blue.withOpacity(0.5);
    case 5:
      return Colors.green.withOpacity(0.5);
    case 6:
      return Colors.purple.withOpacity(0.5);
    case 7:
      return Colors.orange.withOpacity(0.5);
    case 8:
      return Colors.pink.withOpacity(0.5);
    case 9:
      return Colors.teal.withOpacity(0.5);
    default:
      return Colors.grey.withOpacity(0.5);
  }
}

//get colorun tam tersi olan bir fonksiyon yazın
int getcolorNumber(color) {
  return color == Colors.white.withOpacity(0.5)
      ? 1
      : color == Colors.red.withOpacity(0.5)
          ? 2
          : color == Colors.yellow.withOpacity(0.5)
              ? 3
              : color == Colors.blue.withOpacity(0.5)
                  ? 4
                  : color == Colors.green.withOpacity(0.5)
                      ? 5
                      : color == Colors.purple.withOpacity(0.5)
                          ? 6
                          : color == Colors.orange.withOpacity(0.5)
                              ? 7
                              : color == Colors.pink.withOpacity(0.5)
                                  ? 8
                                  : color == Colors.teal.withOpacity(0.5)
                                      ? 9
                                      : color == Colors.grey.withOpacity(0.5)
                                          ? 0
                                          : 10;
}
