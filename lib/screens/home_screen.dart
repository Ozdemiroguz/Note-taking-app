import 'package:firstvisual/models/note.dart';
import 'package:firstvisual/styles/colors.dart';
import 'package:firstvisual/styles/shape.dart';
import 'package:firstvisual/styles/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:firstvisual/widgets/home_widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

List<int> ticklist = [1, 0, 1];
bool isChecked = false;
listNote note = listNote(
  title: "title",
  description: "description",
  date: "date",
  time: "time",
  color: "color",
  id: "id",
  tickDescp: ["aaaaaaaaaaaa", "baaaaaaaaaaaa", "caaaaaaaaa"],
  ticklist: [1, 0, 1],
);

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
          ClipPath(
            clipper: BottomClipper(),
            child: Container(
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                color: AppColors.softBack,
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Hello Oğuzhan ", style: subTitleStyle),
                        Text("Good Morning  ", style: titleStyle),
                        Text("You have xx task today", style: subTitleStyle),
                      ],
                    ),
                    SizedBox(
                        width: width * 0.25,
                        child: Lottie.asset(
                            "animations/Animation - 1705919921302.json")),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.all(width * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TaskContainer(ListNote: note),
                TaskContainer(ListNote: note),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(width * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TaskContainer(ListNote: note),
                TaskContainer(ListNote: note),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
