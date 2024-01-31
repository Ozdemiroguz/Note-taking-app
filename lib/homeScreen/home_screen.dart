import 'package:firstvisual/models/note.dart';
import 'package:firstvisual/styles/colors.dart';
import 'package:firstvisual/styles/shape.dart';
import 'package:firstvisual/styles/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:firstvisual/homeScreen/taskcontainerlist.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

bool isChecked = false;

BasicNote basicNote = BasicNote('Basic', 1, 'Başlık 1', 'Açıklama 1',
    DateTime.now(), DateTime.now().add(Duration(hours: 2)));

TaskListNote taskListNote = TaskListNote(
    'TaskList',
    2,
    'Başlık 1',
    'Açıklama 1',
    DateTime.now(),
    DateTime.now().add(Duration(hours: 2)),
    ['Task 1', 'Task 2', 'Task 3'],
    [false, false, false]);

NoteWithImage noteWithImage = NoteWithImage(
    'NoteWithImage',
    1,
    'Başlık 1',
    'Açıklama 1',
    DateTime.now(),
    DateTime.now().add(Duration(hours: 2)),
    'images/mainlogo.png');
TaskListNote taskListNote2 = TaskListNote(
    'TaskList',
    4,
    'Başlık 2',
    'Açıklama 2',
    DateTime.now(),
    DateTime.now().add(Duration(hours: 2)),
    ['Task 1', 'Task 2', 'Task 3', 'Task 4', 'Task 5', 'Task 6', 'Task 7'],
    [false, false, false, false, false, false, false]);

final List<Note> userNotes = [
  basicNote,
  taskListNote,
  noteWithImage,
  taskListNote2,
];

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextEditingController searchController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
          leading: null,
          flexibleSpace: Container(
            height: height * 0.15,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              color: AppColors.softBack,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 30,
                left: 30,
                right: 30,
              ),
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
          automaticallyImplyLeading: false,
          toolbarHeight: height * 0.17,
          backgroundColor: Colors.transparent,
          elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: SingleChildScrollView(
          child: Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  //remove last element from userNotes
                  setState(() {
                    userNotes.removeLast();
                  });
                },
                child: Text("Remove Last Note"),
              ),
              SizedBox(height: 150),
              // SizedBox(height: 15),
              Padding(
                  padding: EdgeInsets.all(width * 0.05),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: "Search your notes",
                      labelStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                      ),
                    ),
                  )),
              SizedBox(
                height: 500,
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      // TabBar'ı Column içinde kullan
                      TabBar(
                        tabs: [
                          Tab(text: 'All Notes '),
                          Tab(text: 'Tasks'),
                          Tab(text: 'Aims'),
                        ],
                      ),
                      // TabBarView'ı Expanded içinde kulla
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 10, left: width * 0.05, right: width * 0.05),
                          child: TabBarView(
                            children: [
                              // Tab 1 İçeriği

                              MasonryGridView.builder(
                                itemCount: userNotes.length,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                                gridDelegate:
                                    const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  return TaskContainerList(
                                      note: userNotes[index]);
                                },
                              ),
                              Text("Tab 3 içeriği"),
                              Text("Tab 2 içeriği"),

                              // Tab 2 İçeriği
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
} /*  */
