import 'package:firstvisual/onworkingScreen.dart';
import 'package:firstvisual/styles/colors.dart';
import 'package:firstvisual/styles/dateFormat.dart';
import 'package:firstvisual/styles/shape.dart';
import 'package:firstvisual/styles/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget buildLastRow() {
  return Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(10),
      ),
    ),
    child: Icon(
      Icons.arrow_forward_ios,
      size: 20,
    ),
  );
}

Drawer drawerFunc(BuildContext context, int totalnotes) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        SizedBox(
          height: width > 500 ? getHeight(context) * 0.7 : height * 0.4,
          child: DrawerHeader(
            child: Column(
              children: [
                Container(
                  width: 90,
                  child: Lottie.asset("animations/rabbit.json"),
                ),
                Text(
                  'User Name',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text("seryani@gmamil.com",
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    totalnotes.toString(),
                    style: TextStyle(
                        fontSize: 40, color: Colors.white, height: 0.6),
                  ),
                ),
                Text(
                  "Total Notes",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: AppColors.softBack,
            ),
          ),
        ),
        ListTile(
          title: Text('My Profile'),
          onTap: () {
            // Navigate to the user's profile page
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return UnderConstructionPage();
            }));
          },
        ),
        ListTile(
          title: Text('Settings'),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return UnderConstructionPage();
            }));
          },
        ),
      ],
    ),
  );
}

AppBar appBar(BuildContext context) {
  int hour = DateTime.now().hour;

  String greeting;
  if (hour < 12) {
    greeting = 'Good Morning';
  } else if (hour < 17) {
    greeting = 'Good Afternoon';
  } else {
    greeting = 'Good Evening';
  }
  return AppBar(
      leading: null,
      flexibleSpace: Container(
        width: 10,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          color: AppColors.softBack,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: getHeight(context) > 500 ? 30 : 15,
            left: 30,
            right: 30,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //saate göre good morning good afternoon good evening
                  Row(
                    children: [
                      Text(greeting,
                          style: getWidth(context) > 500
                              ? titleStyleTablet
                              : titleStyle),
                      SizedBox(
                          width: getWidth(context) > 500 ? 80 : 60,
                          child: Lottie.asset(greeting == "Good Morning"
                              ? "animations/Animation - 1705919921302.json"
                              : (greeting == "Good Afternoon"
                                  ? "animations/Animation - 1705919921302.json"
                                  : "animations/Animation - 1708029725337.json")))
                    ],
                  ),
                  Text(
                    format1(DateTime.now()),
                    style: TextStyle(
                        fontSize: getWidth(context) > 500 ? 10 : 14,
                        color: Colors.white),
                  )
                ],
              ),
              // user avatar part

              /*SizedBox(
                      width: width * 0.25,
                      child: Lottie.asset(
                          "animations/Animation - 1705919921302.json")),*/
            ],
          ),
        ),
      ),
      actions: [
        //drawer open
        Builder(
          builder: (context) => Container(
            margin: EdgeInsets.only(right: 20),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(100),
              ),
            ),
            child: GestureDetector(
              child: Lottie.asset("animations/rabbit.json"),
              onTap: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        )
      ],
      automaticallyImplyLeading: false,
      toolbarHeight: getHeight(context) * 0.12,
      backgroundColor: Colors.transparent,
      elevation: 0);
}

Widget quetoContainer(BuildContext context, String? queto) {
  return Container(
      width: getWidth(context) * 0.9,
      padding: EdgeInsets.all(10),
      //queto container
      decoration: BoxDecoration(
        color: AppColors.softBack,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "“",
            style: TextStyle(
                fontSize: 30,
                height: 0.8,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          Text(queto!,
              textAlign: TextAlign.center,
              style: TextStyle(
                  height: 1,
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Sevimli Tavşik ",
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  width: 30,
                  child: Divider(
                    color: Colors.grey[500],
                    thickness: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ));
}
