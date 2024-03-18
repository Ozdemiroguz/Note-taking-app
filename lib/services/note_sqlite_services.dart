import 'package:firstvisual/models/folder.dart';
import 'package:firstvisual/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseService {
  late Future<Database> database;

  DatabaseService() {
    database = _initDB();
  }

  Future<Database> _initDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'notes_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE notes(noteId INTEGER PRIMARY KEY, type TEXT, colorNumber INTEGER, title TEXT, description TEXT, date TEXT, finishTime TEXT, imgPaths TEXT, tasks TEXT, fileName TEXT)",
        );
        await db.execute(
          "CREATE TABLE folders(folderId INTEGER PRIMARY KEY,  folderName TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<int> insertNote(DetailedNote note) async {
    final db = await database;
    int id = await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<DetailedNote>> getNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notes');
    return List.generate(maps.length, (i) {
      return DetailedNote.fromMap(maps[i]);
    });
  }

  Future<void> updateNote(DetailedNote note) async {
    final db = await database;
    await db.update(
      'notes',
      note.toMap(),
      where: "noteId = ?",
      whereArgs: [note.noteId],
    );
  }

  Future<void> deleteNote(int noteId) async {
    final db = await database;
    await db.delete(
      'notes',
      where: "noteId = ?",
      whereArgs: [noteId],
    );
  }

  Future<void> deleteDB() async {
    String path = join(await getDatabasesPath(), 'notes_database.db');
    await deleteDatabase(path);
  }

  Future<int> insertFolder(Folder folder) async {
    final db = await database;
    int id = await db.insert(
      'folders',
      folder.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<Folder>> getFolders() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('folders');
    return List.generate(maps.length, (i) {
      return Folder.fromMap(maps[i]);
    });
  }

  Future<void> deleteFolder(int folderId) async {
    final db = await database;

    String folderName = await getFolders().then((value) {
      return value
          .firstWhere((element) => element.folderId == folderId)
          .folderName;
    });
//dosya silinirken notlardan da silinmeli ve notlar güncellenmei
    List<DetailedNote> notes = await getNotes();
    for (DetailedNote note in notes) {
      if (note.fileName.contains(folderName)) {
        note.fileName = note.fileName.replaceAll(folderName, '');
        await updateNote(note);
      }
    }

    await db.delete(
      'folders',
      where: "folderId = ?",
      whereArgs: [folderId],
    );
  }
}
