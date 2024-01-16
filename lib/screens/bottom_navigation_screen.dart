import 'package:firstvisual/screens/home_screen.dart';
import 'package:firstvisual/screens/page2.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: null,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
        padding: const EdgeInsets.only(
            left: 20.0, right: 20.0, bottom: 5.0, top: 5.0),
        //containere border ekleme
        width: MediaQuery.of(context).size.width,

        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
              Radius.circular(20.0)), // Yatayda yuvarlatma ekleyin
          color: Colors.blue, // İstediğiniz arkaplan rengini ayarlayın
        ), //BoxDecoration
        child: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          backgroundColor: Colors.blue,
          elevation: 0.0,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Ana Sayfa',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Arama',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
              backgroundColor: Colors.blue,
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
