import 'dart:convert';

abstract class Note {
  int noteId;
  String type;
  int colorNumber;
  String title;
  String description;
  DateTime date;
  DateTime finishTime;

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
  ) : super(noteId, type, colorNumber, title, description, date, finishTime);

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
    );
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
