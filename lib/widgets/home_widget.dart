import 'package:firstvisual/models/note.dart';
import 'package:flutter/material.dart';

class TaskContainer extends StatefulWidget {
  final listNote ListNote;

  TaskContainer({required this.ListNote});

  @override
  _TaskContainerState createState() => _TaskContainerState();
}

class _TaskContainerState extends State<TaskContainer> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.425,
      decoration: BoxDecoration(color: Colors.yellow.withOpacity(0.5)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.ListNote.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.425,
              child: Column(
                children: List.generate(
                  widget.ListNote.tickDescp.length,
                  (index) => buildRow(widget.ListNote.tickDescp[index], index),
                ),
              ),
            ),
            Text(
              widget.ListNote.date,
              style: TextStyle(fontFamily: 'Poppins'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRow(String labelText, int index) {
    return Row(
      children: [
        Checkbox(
          value: widget.ListNote.ticklist[index] == 1,
          focusColor: Colors.red,
          activeColor: Colors.green,
          onChanged: (bool? value) {},
        ),
        Expanded(
          child: Text(
            labelText,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontFamily: 'Poppins'),
          ),
        ),
      ],
    );
  }
}
