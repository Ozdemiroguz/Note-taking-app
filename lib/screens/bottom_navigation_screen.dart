import 'dart:html';

import 'package:firstvisual/screens/home_screen.dart';
import 'package:firstvisual/screens/page2.dart';
import 'package:flutter/material.dart';
//colors
import 'package:firstvisual/styles/colors.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavigationBarScreenState createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    Page2(),
    Text('Profil'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: null,
      body: Stack(
        children: [
          Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(
          left: width * 0.05,
          right: width * 0.05,
          bottom: width * 0.03,
        ),
        padding: const EdgeInsets.only(
            left: 20.0, right: 20.0, bottom: 5.0, top: 5.0),
        //containere border ekleme
        width: MediaQuery.of(context).size.width,

        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 11,
              spreadRadius: 11,
              offset: Offset(4, 4),
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            bottomRight: Radius.circular(15.0),
          ),
          color: AppColors.darkBack, // İstediğiniz arkaplan rengini ayarlayın
        ), //BoxDecoration
        child: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          elevation: 0.0,
          items: <BottomNavigationBarItem>[
            bottomNavigationBarItem(Icons.home, 'Ana Sayfa'),
            bottomNavigationBarItem(Icons.search, 'Arama'),
            bottomNavigationBarItem(Icons.person, 'Profil'),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

// BottomNavigationBarItem döndüren bir fonksiyon
BottomNavigationBarItem bottomNavigationBarItem(IconData icon, String label) {
  return BottomNavigationBarItem(
    icon: Icon(icon),
    label: label,
    backgroundColor: AppColors.darkBack,
  );
}
