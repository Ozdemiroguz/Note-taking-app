import 'package:flutter/material.dart';
import 'package:firstvisual/screens/signin_screen.dart';
import 'package:firstvisual/screens/bottom_navigation_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uygulama',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignInScreen(),
      routes: {
        '/home': (context) => BottomNavigationBarScreen(),
      },
    );
  }
}
