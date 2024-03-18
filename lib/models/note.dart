import 'dart:convert';

import 'package:flutter/foundation.dart';

abstract class Note {
  int noteId;
  String type;
  int colorNumber;
  String title;
  String description;
  DateTime date;
  DateTime finishTime;

  @override
  int get hasCode {
    return noteId.hashCode ^
        type.hashCode ^
        colorNumber.hashCode ^
        title.hashCode ^
        description.hashCode ^
        date.hashCode ^
        finishTime.hashCode;
  }

  Note(this.noteId, this.type, this.colorNumber, this.title, this.description,
      this.date, this.finishTime);

  Map<String, Object?> toMap() {
    return {
      'noteId': noteId,
      'type': type,
      'colorNumber': colorNumber,
      'title': title,
      'description': description,
      'date': date,
      'finishTime': finishTime,
    };
  }
}

class DetailedNote extends Note {
  List<String> imgPaths;
  List<Task> tasks;
  String fileName;
  DetailedNote(
      int noteId,
      String type,
      int colorNumber,
      String title,
      String description,
      DateTime date,
      DateTime finishTime,
      this.imgPaths,
      this.tasks,
      this.fileName)
      : super(
          noteId,
          type,
          colorNumber,
          title,
          description,
          date,
          finishTime,
        );

  resetNote() {
    //reset the note
    noteId = 0;
    type = 'DetailedNote';
    colorNumber = 0;
    title = 'Add title';
    description = 'Add description';
    date = DateTime.now();
    finishTime = DateTime.now().add(const Duration(days: 2));
    imgPaths = [];
    tasks = [];
    fileName = 'All Notes';
  }

  Map<String, Object?> toMap() {
    return {
      'type': type,
      'colorNumber': colorNumber,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'finishTime': finishTime.toIso8601String(),
      'imgPaths': jsonEncode(imgPaths),
      'tasks': jsonEncode(tasks.map((task) => task.toMap()).toList()),
      'fileName': fileName,
    };
  }

  static DetailedNote fromMap(Map<String, dynamic> map) {
    return DetailedNote(
      map['noteId'],
      map['type'],
      map['colorNumber'],
      map['title'],
      map['description'],
      DateTime.parse(map['date']),
      DateTime.parse(map['finishTime']),
      (jsonDecode(map['imgPaths']) as List<dynamic>).cast<String>(),
      (jsonDecode(map['tasks']) as List<dynamic>)
          .map((taskMap) => Task.fromMap(taskMap))
          .toList(),
      map['fileName'],
    );
  }

  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DetailedNote &&
        other.noteId == noteId &&
        other.type == type &&
        other.colorNumber == colorNumber &&
        other.title == title &&
        other.description == description &&
        other.date == date &&
        other.finishTime == finishTime &&
        listEquals(other.imgPaths, imgPaths) &&
        listEquals(other.tasks, tasks);
  }
}

class Task {
  String task;
  bool isDone;

  Task(this.task, this.isDone);

  Map<String, Object?> toMap() {
    return {
      'task': task,
      'isDone': isDone ? 1 : 0,
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      map['task'],
      map['isDone'] == 1,
    );
  }
}
