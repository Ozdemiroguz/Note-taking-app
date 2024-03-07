import 'package:firstvisual/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:convert';

class DatabaseService {
  late Future<Database> database;

  DatabaseService() {
    database = _initDB();
  }

  Future<Database> _initDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'notes3_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE notes(noteId INTEGER PRIMARY KEY, type TEXT, colorNumber INTEGER, title TEXT, description TEXT, date TEXT, finishTime TEXT, imgPaths TEXT, tasks TEXT)",
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
      print("Notes index $i" + maps[i].toString());
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
    String path = join(await getDatabasesPath(), 'notes3_database.db');
    await deleteDatabase(path);
  }
}
