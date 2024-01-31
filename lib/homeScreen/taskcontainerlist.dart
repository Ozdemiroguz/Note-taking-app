import 'package:firstvisual/models/note.dart';
import 'package:flutter/material.dart';

class TaskContainerList extends StatefulWidget {
  final Note note;

  TaskContainerList({required this.note});

  @override
  _TaskContainerState createState() => _TaskContainerState();
}

class _TaskContainerState extends State<TaskContainerList> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Text(
        widget.note.date.toIso8601String(),
        style: taskdateStyle,
      ),
      Text(
        widget.note.title,
        style: tasktitleStyle,
        overflow: TextOverflow.ellipsis,
      ),
      const Divider(
        thickness: 1,
        color: Colors.black,
      ),
      Text(
        widget.note.description,
        style: tasklisteStyle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      )
    ];
    if (widget.note.type == 'TaskList') {
      print("object");
      children.add(Expanded(
        child: Column(
          // Column'ın boyutlarını dikkatlice ayarlayın
          children: List.generate(
            (widget.note as TaskListNote).tasks.length,
            (index) => buildRow((widget.note as TaskListNote).tasks[index],
                (widget.note as TaskListNote).ticklist[index]),
          ),
        ),
      ));
      //note with image
    } else if (widget.note.type == 'NoteWithImage') {
      children.add(Expanded(
        child: Image.asset(
          (widget.note as NoteWithImage).imagePath,
          fit: BoxFit.cover,
        ),
      ));
    }
    return IntrinsicHeight(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.425,
        decoration: BoxDecoration(
            color: getcolor(widget.note.colorNumber),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
            Positioned(
              child: buildLastRow(),
              top: 0,
              right: 0,
            )
          ],
        ),
      ),
    );
  }

  Widget buildRow(String labelText, bool tick) {
    bool itemsChecked = tick;
    return Row(
      children: [
        Checkbox(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          value: tick,
          focusColor: Colors.red,
          activeColor: Colors.green,
          onChanged: (bool? value) {},
        ),
        Expanded(
          child: Text(
            labelText,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10,
              decoration: itemsChecked ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
      ],
    );
  }
}

TextStyle tasktitleStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 14,
);
TextStyle taskdateStyle = TextStyle(
  color: Colors.grey[900],
  fontSize: 8,
);
TextStyle tasklisteStyle = TextStyle(
  fontSize: 10,
  fontFamily: 'Poppins',
);
Widget buildLastRow() {
  return GestureDetector(
    onTap: () {
      print("pressed");
    },
    child: Container(
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
    ),
  );
}

Color getcolor(colorNumber) {
  switch (colorNumber) {
    case 1:
      return Colors.yellow.withOpacity(0.5);
    case 2:
      return Colors.red.withOpacity(0.5);
    case 3:
      return Colors.green.withOpacity(0.5);
    case 4:
      return Colors.blue.withOpacity(0.5);
    default:
      return Colors.purple.withOpacity(0.5);
  }
}
