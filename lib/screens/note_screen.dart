//statefull wiget

import 'package:firstvisual/homeScreen/taskcontainerlist.dart';
import 'package:firstvisual/models/note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //home: DrawingScreen(),
      home: Page2(),
    );
  }
}

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Page2State createState() => _Page2State();
}

TaskListNote taskListNote = TaskListNote(
    'TaskList',
    1,
    'Başlık 1',
    'Açıklama 1',
    DateTime.now(),
    DateTime.now().add(Duration(hours: 2)),
    ['Task 1', 'Task 2', 'Task 3'],
    [false, false, true]);

class _Page2State extends State<Page2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: TaskContainerList(
        note: taskListNote,
      ),
    );
  }
}
