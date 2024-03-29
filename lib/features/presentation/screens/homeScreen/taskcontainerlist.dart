import 'dart:io';

import 'package:firstvisual/features/data/models/note.dart';
import 'package:firstvisual/styles/colors.dart';
import 'package:firstvisual/styles/dateFormat.dart';
import 'package:firstvisual/styles/shape.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
        widget.note.title,
        style: tasktitleStyle,
        overflow: TextOverflow.ellipsis,
      ),
      const Divider(
        thickness: 1,
        color: Colors.black,
      ),
      widget.note.description == ''
          ? Container()
          : Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                widget.note.description,
                style: tasklisteStyle,
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
              ),
            )
    ];
    if (widget.note is DetailedNote &&
        (widget.note as DetailedNote).imgPaths.length > 0) {
      children.add(SizedBox(
        width: getWidth(context) > 500
            ? getWidth(context) * 0.400
            : getWidth(context) * 0.425,
        height: (widget.note as DetailedNote).imgPaths.length == 2
            ? getWidth(context) * 0.15
            : getWidth(context) > 500
                ? getWidth(context) * 0.2
                : getWidth(context) * 0.425,
        child: MasonryGridView.builder(
          itemCount: (widget.note as DetailedNote).imgPaths.length,
          gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                (widget.note as DetailedNote).imgPaths.length < 2 ? 1 : 2,
          ),
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: Image.file(
                File((widget.note as DetailedNote).imgPaths[index]),
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ));
    }
    if (widget.note is DetailedNote &&
        (widget.note as DetailedNote).tasks.length > 0) {
      children.add(
        Column(
          // Column'ın boyutlarını dikkatlice ayarlayın
          children: List.generate(
            (widget.note as DetailedNote).tasks.length,
            (index) => buildRow(
              (widget.note as DetailedNote).tasks[index],
            ),
          ),
        ),
      );
      //note with image
    }
    children.add(SizedBox(
      height: 20,
    ));

    return Container(
      decoration: BoxDecoration(
          color: getcolor(widget.note.colorNumber),
          borderRadius: BorderRadius.all(Radius.circular(7))),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

TextStyle tasktitleStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 20,
);
TextStyle taskdateStyle = TextStyle(
  color: Colors.grey[900],
  fontSize: 8,
);
TextStyle tasklisteStyle = TextStyle(
  fontSize: 10,
  fontFamily: 'Poppins',
);
