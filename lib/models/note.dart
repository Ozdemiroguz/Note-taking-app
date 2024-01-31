abstract class Note {
  String type;
  int colorNumber;
  String title;
  String description;
  DateTime date;
  DateTime finishTime;

  Note(this.type, this.colorNumber, this.title, this.description, this.date,
      this.finishTime);
}

class TaskListNote extends Note {
  List<String> tasks;
  List<bool> ticklist;

  TaskListNote(String type, int colorNumber, String title, String description,
      DateTime date, DateTime finishTime, this.tasks, this.ticklist)
      : super(type, colorNumber, title, description, date, finishTime);
}

class NoteWithImage extends Note {
  String imagePath;

  NoteWithImage(String type, int colorNumber, String title, String description,
      DateTime date, DateTime finishTime, this.imagePath)
      : super(type, colorNumber, title, description, date, finishTime);
}

class BasicNote extends Note {
  BasicNote(String type, int colorNumber, String title, String description,
      DateTime date, DateTime finishTime)
      : super(type, colorNumber, title, description, date, finishTime);
}
