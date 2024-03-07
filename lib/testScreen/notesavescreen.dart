import 'package:firstvisual/models/note.dart';
import 'package:firstvisual/services/noteServices.dart';
import 'package:firstvisual/services/note_sqlite_services.dart';
import 'package:flutter/material.dart';

/*void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notlar Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: tableScreen(title: 'Notlar Uygulaması'),
    );
  }
}
*/
class tableScreen extends StatefulWidget {
  tableScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<tableScreen> {
  DatabaseService dbService = DatabaseService();
  List<DetailedNote> notes = [];

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  void _refreshNotes() async {
    List<DetailedNote> freshNotes = await dbService.getNotes();
    setState(() {
      notes = freshNotes;
      for (var note in notes) {
        print("Note: " + note.toMap().toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notes[index].title),
            subtitle: Column(
              children: [
                Text(notes[index].noteId.toString()),
                Text(notes[index].description),
                Text(notes[index].date.toString()),
                Text(notes[index].finishTime.toString()),
                Text(notes[index].imgPaths.toString()),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                NoteService noteService = NoteService();
                await noteService.deleteNote(notes[index]);

                _refreshNotes();
              },
            ),
          );
        },
      ),

      floatingActionButton: Row(
        children: [
          FloatingActionButton(
            onPressed: () async {
              DetailedNote note = DetailedNote(
                2,
                'type1',
                0,
                'title',
                'description',
                DateTime.now(),
                DateTime.now(),
                ['imgPath1', 'imgPath2'],
                [
                  Task('task1', false),
                  Task('task2', true),
                ],
              );

              int id = await dbService.insertNote(note);
              print("Note id: $id");
              _refreshNotes();
            },
            tooltip: 'Not Ekle',
            child: Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () async {
              print("delete db");
              await dbService.deleteDB();
              _refreshNotes();
            },
            tooltip: 'Veritabanını Sil',
            child: Icon(Icons.delete),
          ),
        ],
      ),
      //delete database button
    );
  }
}
