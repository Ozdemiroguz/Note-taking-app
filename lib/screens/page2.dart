//statefull wiget
/*
import 'package:firstvisual/homeScreen/taskcontainerlist.dart';
import 'package:firstvisual/models/note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Page2State createState() => _Page2State();
}

ListNote todoList = ListNote(
  title: "Yapılacaklar",
  description: "description",
  date: "11/11/2024",
  time: "2 days remain",
  color: "color",
  id: "id",
  tickDescp: ["Homepage", "Homepage container", "Homepage design"],
  ticklist: [false, false, false],
);

class _Page2State extends State<Page2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: TaskContainerList(
        listNote: todoList,
      ),
    );
  }
}*/
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DrawingScreen(),
    );
  }
}

class DrawingScreen extends StatefulWidget {
  @override
  _DrawingScreenState createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  List<Offset> points = [];
  double strokeWidth = 2.0;
  Color strokeColor = Colors.black;
  bool isErasing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Çizim Ekranı'),
        actions: [
          IconButton(
            icon: Icon(Icons.color_lens),
            onPressed: () {
              setState(() {
                strokeColor =
                    strokeColor == Colors.black ? Colors.red : Colors.black;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.brush),
            onPressed: () {
              setState(() {
                strokeWidth = strokeWidth == 2.0 ? 5.0 : 2.0;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.remove_circle_outlined),
            onPressed: () {
              setState(() {
                isErasing = !isErasing;
              });
            },
          ),
        ],
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            points.add(renderBox.globalToLocal(details.globalPosition));
          });
        },
        onPanStart: (details) {
          setState(() {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            points.add(renderBox.globalToLocal(details.globalPosition));
          });
        },
        onPanEnd: (details) {
          setState(() {
            points.add(points.last);
          });
        },
        child: CustomPaint(
          painter: DrawingPainter(
              points: points,
              strokeColor: strokeColor,
              strokeWidth: strokeWidth,
              isErasing: isErasing),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset> points;
  final Color strokeColor;
  final double strokeWidth;
  final bool isErasing;

  DrawingPainter(
      {required this.points,
      required this.strokeColor,
      required this.strokeWidth,
      required this.isErasing});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = isErasing ? Colors.white : strokeColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}
