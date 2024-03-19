//statefull wiget

import 'dart:io';

import 'package:firstvisual/models/folder.dart';
import 'package:firstvisual/models/note.dart';
import 'package:firstvisual/screens/drawingPage/drawing_app.dart';
import 'package:firstvisual/services/ImageService.dart';
import 'package:firstvisual/services/noteServices.dart';
import 'package:firstvisual/services/note_sqlite_services.dart';
import 'package:firstvisual/styles/colors.dart';
import 'package:firstvisual/styles/dateFormat.dart';
import 'package:firstvisual/styles/shape.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sqflite/sqlite_api.dart';

class NoteScreen extends StatefulWidget {
  final Note note;
  const NoteScreen({super.key, required this.note});

  @override
  // ignore: library_private_types_in_public_api
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<NoteScreen> {
  DatabaseService databaseService = DatabaseService();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool shouldSave = true;
  List<TextEditingController> taskControllers = [];
  List<Folder> folders = [];
  String dropdownValue = ''; // İlk değeri varsayılan olarak seçtik.
  // İlk değeri varsayılan olarak seçtik.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dropdownValue = (widget.note as DetailedNote).fileName == ''
        ? "All Notes"
        : (widget.note as DetailedNote).fileName;
    _getFolders();
    DetailedNote initalNote = widget.note as DetailedNote;
    taskControllers = List.generate(
      (widget.note as DetailedNote).tasks.length,
      (index) => TextEditingController(
          text: (widget.note as DetailedNote).tasks[index].task),
    );
  }

  _getFolders() async {
    List<Folder> _folders = await databaseService.getFolders();
    setState(() {
      folders = _folders;
    });
  }

  @override
  Widget build(BuildContext context) {
    titleController.text = widget.note.title;
    descriptionController.text = widget.note.description;

    List<Widget> children = [];

    if (widget.note is DetailedNote &&
        (widget.note as DetailedNote).imgPaths.length > 0) {
      children.add(ImagePart());
    }

    children.add(DescPart());

    if (widget.note is DetailedNote &&
        (widget.note as DetailedNote).tasks.length > 0) {
      children.add(TaskPart()); //note with image
    }
    // ignore: unnecessary_statements
    children.add(SizedBox(height: 100));
    //save and delete buttons
    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: Scaffold(
            backgroundColor: getcolor(widget.note.colorNumber),
            appBar: AppBar(
              //geri giderken shouldsave boolunu kontrol edip eminmisiniz idye soran bir alert dialog olustur
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () async {
                  _backFunction(context);
                },
              ),

              toolbarHeight: 100,
              backgroundColor: Colors.white,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  color: getcolor(widget.note.colorNumber),
                  //only bottom border black
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 100,
                      ),
                      SizedBox(
                        height: 80,
                        width: 200,
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: titleController,
                          onChanged: (value) {
                            setState(() {
                              widget.note.title = value;
                              shouldSave = false;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: "Add title",
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20, top: 35),
                            child: Text("${format3(widget.note.date)}",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[800],
                                ),
                                textAlign: TextAlign.start),
                          ),
                          DropdownButton<String>(
                            //ıconu kaldır
                            icon: Icon(null),
                            value: dropdownValue,
                            onChanged: (newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                                (widget.note as DetailedNote).fileName =
                                    dropdownValue;
                                shouldSave = false;
                              });
                            },
                            //folders itemları
                            items:
                                folders.map<DropdownMenuItem<String>>((folder) {
                              return DropdownMenuItem<String>(
                                value: folder.folderName,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.folder,
                                      size: 14,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(folder.folderName,
                                        style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          width: getWidth(context),
          bottom: 15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              addTaskButton(),
              addImage(),
              addDraw(),
              choiceColor(),
              deleteButton(),
              //file name seçceğimiz bir dropdown
            ],
          ),
        ),
      ],
    );
  }

  Future updateImgPath() async {
    ImageService imageService = ImageService();

    setState(() async {
      for (int i = 0; i < (widget.note as DetailedNote).imgPaths.length; i++) {
        print("img path " + (widget.note as DetailedNote).imgPaths[i]);
        (widget.note as DetailedNote).imgPaths[i] =
            await imageService.convertTemporaryPathToPermanent(
                (widget.note as DetailedNote).imgPaths[i]);
        print("img path " + (widget.note as DetailedNote).imgPaths[i]);
      }
    });
  }

  Widget addTaskButton() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: FloatingActionButton(
        heroTag: "btn7",
        onPressed: () {
          TextEditingController taskController = TextEditingController();
          print("Add Task");

          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Add Task"),
                  content: TextField(
                    controller: taskController,
                    decoration: InputDecoration(
                      labelText: "Task",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            (widget.note as DetailedNote)
                                .tasks
                                .add(Task(taskController.text, false));
                            taskControllers.add(TextEditingController(
                              text: taskController.text,
                            ));
                            shouldSave = false;
                            Navigator.pop(context);
                          });
                        },
                        child: Text("Add Task"))
                  ],
                );
              });
        },
        child: Icon(Icons.add_task_outlined, color: Colors.black),
      ),
    );
  }

  Widget addImage() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: FloatingActionButton(
        heroTag: "btn6",
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(Icons.camera_alt),
                      title: Text("Camera"),
                      onTap: () async {
                        ImageService imageService = ImageService();
                        String? imgPath =
                            await imageService.getImageFromCamera();
                        print("camera img path " + imgPath!);
                        if (imgPath != null) {
                          setState(() {
                            (widget.note as DetailedNote).imgPaths.add(imgPath);
                            shouldSave = false;
                          });
                        }
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.image),
                      title: Text("Gallery"),
                      onTap: () async {
                        ImageService imageService = ImageService();
                        String? imgPath =
                            await imageService.getImageFromGallery();
                        print("gallery img path " + imgPath!);
                        if (imgPath != null) {
                          setState(() {
                            (widget.note as DetailedNote).imgPaths.add(imgPath);
                            shouldSave = false;
                          });
                        }
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              });
        },
        child: Icon(Icons.add_a_photo_outlined, color: Colors.black),
      ),
    );
  }

  Widget addDraw() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: FloatingActionButton(
        heroTag: "btn5",
        onPressed: () async {
          String? imgPath = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DrawingApp(),
            ),
          );
          print("draw img path " + imgPath!);
          if (imgPath != null) {
            setState(() {
              (widget.note as DetailedNote).imgPaths.add(imgPath);
              shouldSave = false;
            });
          }
        },
        child: Icon(Icons.brush_outlined, color: Colors.black),
      ),
    );
  }

  Widget deleteButton() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: FloatingActionButton(
        heroTag: "btn4",
        onPressed: () async {
          final bool? confirm = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Are you sure?'),
                content: Text('Are you sure you want to delete this note?'),
                actions: <Widget>[
                  TextButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  TextButton(
                    child: Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            },
          );

          if (confirm == true) {
            NoteService noteService = NoteService();
            await noteService.deleteNote(widget.note as DetailedNote);
            Navigator.pop(context);
          }
        },
        child: Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget saveButton() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: FloatingActionButton(
        heroTag: "btn3",
        onPressed: () async {
          saveTask();
        },
        child: Icon(
          Icons.save,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget infoButton() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: FloatingActionButton(
        heroTag: "btn2",
        onPressed: () async {
          print("widget title " + widget.note.title);
          print("widget description " + widget.note.description);
          print("widget colorNumber " + widget.note.colorNumber.toString());
          print("widget noteId " + widget.note.noteId.toString());
          print("widget imgPaths " +
              (widget.note as DetailedNote).imgPaths.toString());
          print(
              "widget tasks " + (widget.note as DetailedNote).tasks.toString());
          await updateImgPath();

          print("widget imgPaths " +
              (widget.note as DetailedNote).imgPaths.toString());
        },
        child: Icon(Icons.info),
      ),
    );
  }

  Widget choiceColor() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: FloatingActionButton(
        heroTag: "btn1",
        onPressed: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Choose Color"),
                content: BlockPicker(
                  availableColors: [
                    getcolor(1),
                    getcolor(2),
                    getcolor(3),
                    getcolor(4),
                    getcolor(5),
                    getcolor(6),
                    getcolor(7),
                    getcolor(8),
                    getcolor(9),
                    getcolor(10),
                  ],
                  onColorChanged: (Color color) {
                    setState(() {
                      widget.note.colorNumber = getcolorNumber(color);
                      shouldSave = false;
                    });
                  },
                  pickerColor: getcolor(widget.note.colorNumber),
                ),
              );
            },
          );
        },
        child: Icon(Icons.color_lens, color: Colors.black),
      ),
    );
  }

  Future saveTask1() async {
    NoteService noteService = NoteService();
    int id = -1;

    if (widget.note.noteId == -1) {
      id = await noteService.saveNote(widget.note as DetailedNote);
      if (id != -1) {
        setState(() {
          widget.note.noteId = id;
        });
        await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: 90,
            right: 20,
            left: 20,
          ),
          content: Text("Note saved"),
        ));
        shouldSave = true;
      }
    } else {
      await noteService.updateNote(widget.note as DetailedNote);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: 90,
          right: 20,
          left: 20,
        ),
        content: Text(
          "Note updated",
          textAlign: TextAlign.center,
        ),
      ));
      shouldSave = true;
    }
  }

  Future saveTask() async {
    NoteService noteService = NoteService();
    int id = -1;
    setState(() {
      widget.note.title = titleController.text;
      widget.note.description = descriptionController.text;
    });

    if (widget.note.noteId == -1) {
      id = await noteService.saveNote(widget.note as DetailedNote);
      if (id != -1)
        setState(() async {
          widget.note.noteId = id;
          await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              bottom: 20,
              right: 20,
              left: 20,
            ),
            content: Text("Note saved"),
          ));
          shouldSave = true;
        });
    } else {
      setState(() async {
        await noteService.updateNote(widget.note as DetailedNote);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: 20,
            right: 20,
            left: 20,
          ),
          content: Text(
            "Note updated",
            textAlign: TextAlign.center,
          ),
        ));
        shouldSave = true;
      });
    }
  }

//image part
  Widget ImagePart() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: SizedBox(
          width: getWidth(context) * 0.9,
          child: SizedBox(
            width: getWidth(context) * 0.425,
            height: getWidth(context) *
                ((widget.note as DetailedNote).imgPaths.length == 2
                    ? 0.45
                    : 0.9),
            child: MasonryGridView.builder(
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              itemCount: (widget.note as DetailedNote).imgPaths.length,
              gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    (widget.note as DetailedNote).imgPaths.length < 2 ? 1 : 2,
              ),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {},
                  child: GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          content: Image.file(
                            File((widget.note as DetailedNote).imgPaths[index]),
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                    child: Stack(
                      children: [
                        Image.file(
                          File((widget.note as DetailedNote).imgPaths[index]),
                          fit: BoxFit.cover,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              (widget.note as DetailedNote)
                                  .imgPaths
                                  .removeAt(index);
                            });
                          },
                          icon: Icon(
                            Icons.delete,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

//description part
  Widget DescPart() {
    return TextField(
      controller: descriptionController,
      onChanged: (value) {
        setState(() {
          widget.note.description = value.toString();
          shouldSave = false;
        });
      },

      maxLines: null, // Sınırsız sayıda satıra izin verir
      decoration: InputDecoration(
        hintText: "Add description",
        border: InputBorder.none,
      ),
      style: TextStyle(
        fontSize: 20,
      ),
    );
  }

//task part
  Widget TaskPart() {
    return Column(
      children: List.generate(
        (widget.note as DetailedNote).tasks.length,
        (index) => Row(
          children: [
            Checkbox(
              value: (widget.note as DetailedNote).tasks[index].isDone,
              onChanged: (bool? value) {
                setState(() {
                  (widget.note as DetailedNote).tasks[index].isDone = value!;
                  shouldSave = false;
                });
              },
            ),
            Expanded(
              child: TextField(
                controller: taskControllers[index],
                onChanged: (value) {
                  setState(() {
                    (widget.note as DetailedNote).tasks[index].task =
                        value.toString();
                    shouldSave = false;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Task",
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(
                  fontSize: 14,
                  decoration: (widget.note as DetailedNote).tasks[index].isDone
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  (widget.note as DetailedNote).tasks.removeAt(index);
                  shouldSave = false;
                });
              },
              child: Icon(Icons.delete),
            )
          ],
        ),
      ),
    );
  }

//back function
  void _backFunction(BuildContext context) async {
    if (shouldSave) {
      print("not changed");
    } else {
      print("changed");
      await saveTask1();
    }

    Navigator.pop(context);
  }
}
