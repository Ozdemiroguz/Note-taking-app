import 'package:firstvisual/styles/colors.dart';
import 'package:firstvisual/styles/textStyle.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: null,
      body: Center(
          child: Column(
        children: [
          // SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50)),
              //color with opacity
              color: const Color.fromARGB(255, 8, 123, 144),

              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 1,
                    spreadRadius: 1,
                    offset: Offset(4, 4)),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome Name Surname", style: titleStyle),
                  Text(
                      "Quote of the day:It is during our darkest moments that we must focus to see the light.",
                      style: subTitleStyle),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Notes: 17", style: subTitleStyle),
                      SizedBox(width: 50),
                      Text("Done notes :11", style: subTitleStyle),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
