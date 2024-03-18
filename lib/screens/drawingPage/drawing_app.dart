import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:firstvisual/screens/drawingPage/drawing_area.dart';
import 'package:firstvisual/screens/drawingPage/my_custom_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:path_provider/path_provider.dart';

class DrawingApp extends StatefulWidget {
  @override
  _DrawingAppState createState() => _DrawingAppState();
}

class _DrawingAppState extends State<DrawingApp> {
  GlobalKey _globalKey = GlobalKey();

  // Diğer değişkenler ve fonksiyonlar buraya eklenecek

// Diğer değişkenler ve fonksiyonlar buraya eklenecek

  Future<void> _captureAndSaveImage() async {
    RenderRepaintBoundary? boundary =
        _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      return;
    }

    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    print(pngBytes);

    // Geçici bir dosya oluşturun
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    File tempFile = File('$tempPath/image_$timestamp.png');
    // Çizimi geçici dosyaya yazın
    await tempFile.writeAsBytes(pngBytes);
    print("tempfile.path" + tempFile.path);

    // Dosya yolunu döndürün
    Navigator.pop(context, tempFile.path);
  }

  Color selectedColor = Colors.black;
  Color tempColor = Colors.black;
  double strokeWidth = 2.0;
  List<DrawingArea> points = [];
  List<List<DrawingArea>> allPoints = [];
  Color backgroundColor = Colors.white;
  bool isErasing = false;
  List<Color> availableColors = [
    Colors.white,
    Colors.black,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.pink,
    Colors.purple,
    Colors.orange,
    Colors.brown,
    Colors.grey,
    Colors.teal,
    Colors.cyan,
    Colors.indigo,
    Colors.lime,
    Colors.amber,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.deepOrange,
    Colors.deepPurple,
  ];

  void selectColor() {
    if (isErasing) {
      selectedColor = tempColor;
    }

    isErasing = false;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Renk seçin'),
        content: BlockPicker(
          availableColors: availableColors,
          pickerColor: selectedColor,
          onColorChanged: (color) {
            setState(() {
              selectedColor = color;
              tempColor = color;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drawing App'),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: backgroundColor,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: GestureDetector(
                    onPanDown: (details) {
                      this.setState(() {
                        points.add(DrawingArea(
                            point: details.localPosition,
                            areaPaint: Paint()
                              ..strokeCap = StrokeCap.round
                              ..isAntiAlias = true
                              ..color = selectedColor
                              ..strokeWidth = strokeWidth));
                      });
                    },
                    onPanUpdate: (details) {
                      this.setState(() {
                        points.add(DrawingArea(
                            point: details.localPosition,
                            areaPaint: Paint()
                              ..strokeCap = StrokeCap.round
                              ..isAntiAlias = true
                              ..color = selectedColor
                              ..strokeWidth = strokeWidth));
                      });
                    },
                    onPanEnd: (details) {
                      this.setState(() {
                        points.add(
                          DrawingArea(
                              point: Offset.infinite,
                              areaPaint: Paint()
                                ..strokeCap = StrokeCap.round
                                ..isAntiAlias = true
                                ..color = selectedColor
                                ..strokeWidth = strokeWidth),
                        );
                        allPoints.add(List.from(points));
                      });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      child: RepaintBoundary(
                        key: _globalKey,
                        child: CustomPaint(
                          painter: MyCustomPainter(
                              points: points, backgroundColor: backgroundColor),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  height: MediaQuery.of(context).size.height * 0.10,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit,
                            color: isErasing ? Colors.grey : tempColor),
                        onPressed: selectColor,
                      ),
                      Expanded(
                          child: Slider(
                        min: 1.0,
                        max: 30.0,
                        activeColor: isErasing ? Colors.grey : tempColor,
                        value: strokeWidth,
                        onChanged: (value) {
                          this.setState(() {
                            strokeWidth = value;
                          });
                        },
                      )),
                      IconButton(
                        icon: Icon(Icons.layers_clear),
                        onPressed: () {
                          this.setState(() {
                            points.clear();
                            allPoints.clear();
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.undo),
                        onPressed: () {
                          this.setState(() {
                            if (allPoints.isNotEmpty) {
                              allPoints.removeLast();
                              points =
                                  allPoints.expand((list) => list).toList();
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.cleaning_services,
                            color: isErasing ? Colors.black : Colors.grey),
                        onPressed: () {
                          setState(() {
                            if (!isErasing) {
                              tempColor = selectedColor;
                              selectedColor = backgroundColor;
                            }
                            isErasing = true;
                          });
                        },
                      ),
                      IconButton(
                          onPressed: () {
                            if (isErasing) {
                              selectedColor = tempColor;
                            }

                            isErasing = false;
                          },
                          icon: Icon(Icons.edit)),
                      //change background color
                      IconButton(
                        icon: Icon(Icons.format_color_fill),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Arka plan rengi seçin'),
                              content: BlockPicker(
                                availableColors: availableColors,
                                pickerColor: backgroundColor,
                                onColorChanged: (color) {
                                  setState(() {
                                    backgroundColor = color;
                                    if (isErasing) {
                                      selectedColor = color;
                                    }
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          FloatingActionButton(
              child: Icon(Icons.save),
              onPressed: () {
                _captureAndSaveImage();
              }),
        ],
      ),
    );
  }
}

class ShowImagePage extends StatelessWidget {
  final Uint8List imageBytes;

  ShowImagePage({required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Saved Image'),
      ),
      body: Center(
        child: Container(
            color: Colors.blue,
            width: 400,
            height: 400,
            child: Image.memory(imageBytes)),
      ),
    );
  }
}
