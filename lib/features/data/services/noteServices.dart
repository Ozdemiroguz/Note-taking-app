import 'dart:io';

import 'package:firstvisual/features/data/models/note.dart';
import 'package:firstvisual/features/data/services/ImageService.dart';
import 'package:firstvisual/features/data/services/note_sqlite_services.dart';

class NoteService {
  DatabaseService dbService = DatabaseService();
  ImageService imgService = ImageService();

  Future<int> saveNote(DetailedNote note) async {
    // Geçici resim yollarını kalıcı hale getir
    List<String> newImgPaths = [];
    for (String tempPath in note.imgPaths) {
      String newPath = tempPath;
      await imgService.convertTemporaryPathToPermanent(tempPath);
      newImgPaths.add(newPath);
    }

    // Yeni resim yollarıyla notu güncelle
    note.imgPaths = newImgPaths;

    // Notu kaydet ve yeni notun ID'sini al
    int noteId = await dbService.insertNote(note);

    // Yeni notun ID'sini döndür
    return noteId;
  }

  Future<void> deleteNote(DetailedNote note) async {
    // Nota ait kalıcı resimleri sil
    for (String path in note.imgPaths) {
      final file = File(path);

      if (await file.exists()) {
        await file.delete();
      }
    }

    // Notu sil
    await dbService.deleteNote(note.noteId);
  }

  Future<void> updateNote(DetailedNote note) async {
    // Yeni eklenen geçici resim yollarını kalıcı hale getir
    List<String> newImgPaths = [];
    for (String path in note.imgPaths) {
      if (path.startsWith('file://')) {
        // Geçici dosya yolu kontrolü
        String newPath = await imgService.convertTemporaryPathToPermanent(path);
        newImgPaths.add(newPath);
      } else {
        newImgPaths.add(path); // Zaten kalıcı olan resim yollarını koru
      }
    }

    // Yeni resim yollarıyla notu güncelle
    note.imgPaths = newImgPaths;

    // Notu veritabanında güncelle
    await dbService.updateNote(note);
  }
}
