import 'package:firstvisual/features/data/models/note.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

String formatDate(DateTime date) {
  // Ay isimlerini içeren bir liste

  // Gün, Ay ve Yılı alarak tarihi biçimlendirme
  String formattedDate = DateFormat('d MMMM h:mm a').format(date);
  return formattedDate;
}

Widget buildRow(Task task) {
  bool itemsChecked = task.isDone;
  return Row(
    children: [
      Checkbox(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        value: task.isDone,
        focusColor: Colors.red,
        activeColor: Colors.green,
        onChanged: (bool? value) {},
      ),
      Expanded(
        child: Text(
          task.task,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            decoration: itemsChecked ? TextDecoration.lineThrough : null,
          ),
        ),
      ),
    ],
  );
}

double getWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}
