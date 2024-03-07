import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resim Kaydetme Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Resim Kaydetme Uygulaması'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  XFile? _tempImage;
  File? _image;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  _getFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        _tempImage = pickedFile;
      });
    }
  }

  _getFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        _tempImage = pickedFile;
      });
    }
  }

  _saveNote() async {
    if (_tempImage != null) {
      final File imageFile = File(_tempImage!.path);
      final Directory directory = await getApplicationDocumentsDirectory();
      final String path = directory.path;
      final File newImage = await imageFile.copy('$path/image.png');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('imagePath', newImage.path);

      setState(() {
        _image = newImage;
        _tempImage = null;
      });
    }

    // Notun diğer kısımlarını kaydedin...
  }

  _loadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('imagePath');

    if (imagePath != null) {
      setState(() {
        _image = File(imagePath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image != null
                ? Image.file(_image!)
                : Text('Henüz bir resim seçilmedi.'),
            ElevatedButton(
              onPressed: _getFromGallery,
              child: Text('Galeriden Resim Seç'),
            ),
            ElevatedButton(
              onPressed: _getFromCamera,
              child: Text('Kameradan Resim Çek'),
            ),
            ElevatedButton(
              onPressed: _saveNote,
              child: Text('Notu Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
