import 'package:firstvisual/features/data/models/folder.dart';
import 'package:firstvisual/features/data/models/note.dart';
import 'package:firstvisual/features/data/services/noteServices.dart';
import 'package:firstvisual/features/data/services/note_sqlite_services.dart';
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
  List<Folder> folders = [];

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  void _refreshNotes() async {
    List<DetailedNote> freshNotes = await dbService.getNotes();
    List<Folder> _folders = await dbService.getFolders();
    setState(() {
      notes = freshNotes;
      folders = _folders;
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
      body: Column(
        children: [
          SizedBox(
            height: 300,
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(notes[index].title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(notes[index].noteId.toString()),
                      Text(notes[index].description),
                      Text(notes[index].date.toString()),
                      Text(notes[index].finishTime.toString()),
                      Text(notes[index].imgPaths.toString()),
                      Text("filename: " + notes[index].fileName.toString()),
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
          ),
          SizedBox(
            height: 300,
            child: ListView.builder(
              itemCount: folders.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(folders[index].folderName),
                  subtitle: Text(folders[index].folderId.toString()),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await dbService.deleteFolder(folders[index].folderId);
                      _refreshNotes();
                    },
                  ),
                );
              },
            ),
          ),
        ],
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
                  '');

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
          FloatingActionButton(
            onPressed: () {
              //add file to database before open show dialog and ask for file
              TextEditingController _textFieldController =
                  TextEditingController();
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Dosya Adı Girin'),
                    content: TextField(
                      controller: _textFieldController,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: 'Dosya Adı',
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('İptal'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Add File'),
                        onPressed: () async {
                          //add file to database
                          Folder folder = Folder(0, _textFieldController.text);
                          await dbService.insertFolder(folder);
                          Navigator.of(context).pop();
                          _refreshNotes();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Icon(Icons.add),
          )
        ],
      ),

      //delete database button
    );
  }
}
