import 'dart:math';

import 'package:firstvisual/features/data/models/folder.dart';
import 'package:firstvisual/features/data/models/queto.dart';
import 'package:firstvisual/features/presentation/screens/drawingPage/drawing_app.dart';
import 'package:firstvisual/features/presentation/screens/homeScreen/widget.dart';
import 'package:firstvisual/features/data/models/note.dart';
import 'package:firstvisual/features/data/services/ImageService.dart';
import 'package:firstvisual/features/data/services/note_sqlite_services.dart';
import 'package:firstvisual/styles/colors.dart';
import 'package:firstvisual/styles/dateFormat.dart';
import 'package:firstvisual/styles/shape.dart';
import 'package:firstvisual/testScreen/notesavescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:freestyle_speed_dial/freestyle_speed_dial.dart';
import 'package:firstvisual/features/presentation/screens/homeScreen/taskcontainerlist.dart';
import 'package:lottie/lottie.dart';

import '../noteScreen/note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

String? imgPath;
String? queto = 'Today is a brand new day to achieve something.';
Quote quote = Quote(
    author: "CuttieRabbit",
    quote: "Today is a brand new day to achieve something.");

DetailedNote defaultNote = DetailedNote(-1, 'Type', 1, "", "", DateTime.now(),
    DateTime.now().add(const Duration(days: 2)), [], [], '');

class _HomeScreenState extends State<HomeScreen> {
  DatabaseService dbService = DatabaseService();

  List<DetailedNote> notes = [];
  List<DetailedNote> filteredNotes = [];
  List<Folder> folders = [];
  String selectedFolder = "All Notes";
  List<String> categories = [
    "age",
    "alone",
    "amazing",
    "anger",
    "architecture",
    "art",
    "attitude",
    "beauty",
    "best",
    "birthday",
    "business",
    "car",
    "change",
    "communication",
    "computers",
    "cool",
    "courage",
    "dad",
    "dating",
    "death",
    "design",
    "dreams",
    "education",
    "environmental",
    "equality",
    "experience",
    "failure",
    "faith",
    "family",
    "famous",
    "fear",
    "fitness",
    "food",
    "forgiveness",
    "freedom",
    "friendship",
    "funny",
    "future",
    "god",
    "good",
    "government",
    "graduation",
    "great",
    "happiness",
    "health",
    "history",
    "home",
    "hope",
    "humor",
    "imagination",
    "inspirational",
    "intelligence",
    "jealousy",
    "knowledge",
    "leadership",
    "learning",
    "legal",
    "life",
    "love",
    "marriage",
    "medical",
    "men",
    "mom",
    "money",
    "morning",
    "movies",
    "success"
  ];
  String dropdownValue = 'learning';

  @override
  void initState() {
    super.initState();
    _refreshNotes();
    fetchQuote();
  }

  void _refreshNotes() async {
    List<DetailedNote> freshNotes = await dbService.getNotes();
    List<Folder> _folders = await dbService.getFolders();
    setState(() {
      folders = _folders;
      //folders boşşsa All Notes Ekle
      if (folders.isEmpty) {
        folders.add(Folder(-1, "All Notes"));
        dbService.insertFolder(Folder(-1, "All Notes"));
      }

      notes = freshNotes.reversed.toList();
      filteredNotes = notes;
    });
  }

  final quoteService = QuoteService();

  void fetchQuote() {
    quoteService.fetchQuote(dropdownValue).then((value) {
      setState(() {
        quote = value;
        print("quote: " + quote.quote + quote.author);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: speedDialer(),
        ),
        endDrawer: drawerFunc(context, notes.length),
        appBar: appBar(context),
        body: _buildBody());
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: getWidth(context) * 0.05),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              quetoContainer(context, queto),
              searchController(),
              _notesContainer(),
              SizedBox(
                height: 30,
              )
            ],
          ),
        )),
      ),
    );
  }

  Widget _notesContainer() {
    return SizedBox(
      height: getHeight(context) * 0.78,
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            // TabBar'ı Column içinde kullan
            TabBar(
              indicatorColor: AppColors.softBack,
              tabs: [
                Tab(
                  child: GestureDetector(
                    child: Text(
                      selectedFolder,
                      style: TextStyle(
                        color: AppColors.softBack,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Folders',
                    style: TextStyle(color: AppColors.softBack, fontSize: 16),
                  ),
                )
              ],
            ),
            // TabBarView'ı Expanded içinde kulla
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 10,
                ),
                child: TabBarView(
                  children: [
                    FutureBuilder(
                        future: filterNotes(selectedFolder),
                        builder: (context, snapshot) {
                          //filteed notes boşsa yükleniyor yazısı göster
                          if (filteredNotes.isEmpty) {
                            return Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                      height: getHeight(context) * 0.5,
                                      child: Lottie.asset(
                                          'animations/rabbit.json')),
                                  //boş klasördeki yazı
                                  Text(
                                    "You don't have any notes in this folder",
                                    style: TextStyle(
                                      color: AppColors.softBack,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  )
                                ],
                              ),
                            );
                          }
                          return MasonryGridView.builder(
                            itemCount: filteredNotes.length,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            gridDelegate:
                                SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: getWidth(context) > 600 ? 3 : 2,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Stack(children: [
                                GestureDetector(
                                    child: TaskContainerList(
                                        note: filteredNotes[index]),
                                    onTap: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => NoteScreen(
                                              note: filteredNotes[index]),
                                        ),
                                      ).then((value) {
                                        _refreshNotes();
                                      });
                                    }),
                                Positioned(
                                    bottom: 2,
                                    right: 2,
                                    child: Card(
                                      //borderadius
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5,
                                            right: 5,
                                            top: 1,
                                            bottom: 1),
                                        child: Text(
                                          //file name
                                          filteredNotes[index].fileName,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    )),
                                Positioned(
                                  left: 5,
                                  bottom: 10,
                                  child: Text(
                                    format3(filteredNotes[index].date),
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                )
                              ]);
                            },
                          );
                        }),
                    // Tab 1 İçeriğ
                    /**/
                    //foldersların her birini kara biçiminde gösteceğim grid yapısı
                    GridView.builder(
                      itemCount: folders.length + 1,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: getWidth(context) > 600 ? 3 : 2,
                        crossAxisSpacing: 30,
                        mainAxisSpacing: 30,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        //son indexte klasör ekleme butonu olacak

                        if (index == folders.length) {
                          return GestureDetector(
                            onTap: () {
                              Folder folder = Folder(-1, "");
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Add Folder"),
                                    content: TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          folder.folderName = value;
                                        });
                                      },
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await dbService.insertFolder(folder);
                                          Navigator.pop(context);
                                          _refreshNotes();
                                        },
                                        child: Text("Add"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: AppColors.softBack,
                                    size: 90,
                                  ),
                                  Text(
                                    "Add Folder",
                                    style: TextStyle(
                                      color: AppColors.softBack,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        //dosya silme butonu
                        return Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedFolder = folders[index].folderName;
                                });
                                DefaultTabController.of(context).animateTo(0);
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.softBack,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.folder,
                                      color: Colors.white,
                                      size: 90,
                                    ),
                                    Text(
                                      textAlign: TextAlign.center,
                                      folders[index].folderName,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: folders[index].folderName != "All Notes",
                              child: Positioned(
                                right: 10,
                                top: 10,
                                //silme butonu
                                child: GestureDetector(
                                  child: Icon(Icons.delete_rounded,
                                      color: Colors.white),
                                  onTap: () async {
                                    //silmdeen önce uyar
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Delete Folder"),
                                          content: Text(
                                              "Are you sure you want to delete this folder?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                await dbService.deleteFolder(
                                                    folders[index].folderId);
                                                Navigator.pop(context);
                                                _refreshNotes();
                                              },
                                              child: Text("Delete"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget floatingActionButtonCamera() {
    return SizedBox(
      width: 50,
      height: 50,
      child: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        onPressed: () async {
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
                        imgPath = await imageService.getImageFromCamera();
                        Navigator.pop(context);

                        if (imgPath != null) {
                          navigateToNoteScreen();
                        }
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.image),
                      title: Text("Gallery"),
                      onTap: () async {
                        ImageService imageService = ImageService();
                        imgPath = await imageService.getImageFromGallery();
                        Navigator.pop(context);

                        if (imgPath != null) {
                          navigateToNoteScreen();
                        }
                      },
                    ),
                  ],
                );
              });
        },
        child: const Icon(
          Icons.camera_alt,
          size: 20,
          color: Colors.white,
        ),
        backgroundColor: AppColors.softBack,
      ),
    );
  }

  void navigateToNoteScreen() async {
    setState(() {
      defaultNote.imgPaths.length == 0
          ? defaultNote.imgPaths.add(imgPath!)
          : defaultNote.imgPaths[0] = imgPath!;

      defaultNote.noteId = -1;
      defaultNote.title = "";
      defaultNote.tasks = [];
      defaultNote.description = "";
      defaultNote.fileName = 'All Notes';
      defaultNote.colorNumber = 1;
    });

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteScreen(note: defaultNote)),
    );
    _refreshNotes();

    setState(() {
      defaultNote.imgPaths = [];
      imgPath = null;
    });
  }

  Widget floatingActionButtonAddnote() {
    return SizedBox(
      width: 50,
      height: 50,
      child: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        onPressed: () async {
          setDefault();

          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NoteScreen(note: defaultNote)));

          _refreshNotes();
        },
        child: const Icon(Icons.note_add, size: 20, color: Colors.white),
        backgroundColor: AppColors.softBack,
      ),
    );
  }

  Widget floatingActionButtonAddDraw() {
    return SizedBox(
        width: 50,
        height: 50,
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          onPressed: () async {
            imgPath = await Navigator.push(
                context, MaterialPageRoute(builder: (context) => DrawingApp()));
            if (imgPath != null) {
              navigateToNoteScreen();
            }
          },
          child: const Icon(Icons.brush, size: 20, color: Colors.white),
          backgroundColor: AppColors.softBack,
        ));
  }

  void setDefault() {
    setState(() {
      defaultNote.noteId = -1;
      defaultNote.title = "";
      defaultNote.imgPaths = [];
      defaultNote.tasks = [];
      defaultNote.description = "";
      defaultNote.fileName = 'All Notes';
      defaultNote.colorNumber = 1;
    });
  }

  Widget floatingActionButtonTestScreen() {
    return SizedBox(
      width: 50,
      height: 50,
      child: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => tableScreen(title: "Notes"),
            ),
          );
        },
        child: const Icon(Icons.note_add, size: 20, color: Colors.white),
        backgroundColor: AppColors.softBack,
      ),
    );
  }

  Widget speedDialer() {
    return SpeedDialBuilder(
      buttonAnchor: Alignment.center,
      itemAnchor: Alignment.center,
      buttonBuilder: (context, isActive, toggle) => SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          backgroundColor: AppColors.softBack,
          onPressed: toggle,
          child: AnimatedRotation(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubicEmphasized,
            turns: isActive ? 0.125 : 0,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
      itemBuilder: (context, Widget item, i, animation) {
        // radius in relative units to each item
        const radius = 1.5;
        // angle in radians
        final angle = i * (pi / 4) + pi;

        final targetOffset = Offset(
          radius * cos(angle),
          radius * sin(angle),
        );

        final offsetAnimation = Tween<Offset>(
          begin: Offset.zero,
          end: targetOffset,
        ).animate(animation);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: animation,
            child: item,
          ),
        );
      },
      items: [
        floatingActionButtonCamera(),
        floatingActionButtonAddnote(),
        floatingActionButtonAddDraw(),
      ],
    );
  }

  Widget searchController() {
    return Padding(
        padding: EdgeInsets.only(top: 10),
        child: SizedBox(
          height: getHeight(context) * 0.05,
          child: TextField(
            onChanged: (value) => setState(() {
              filteredNotes = notes
                  .where((note) =>
                      note.title.toLowerCase().contains(value.toLowerCase()))
                  .toList();
            }),
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              labelText: "Search your notes",
              labelStyle: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.grey, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.grey, width: 2),
              ),
            ),
          ),
        ));
  }

  Future<void> filterNotes(folderName) async {
    if (folderName == "All Notes") {
      selectedFolder = "All Notes";
      filteredNotes = await notes;
    } else {
      selectedFolder = folderName;
      filteredNotes =
          await notes.where((note) => note.fileName == folderName).toList();
    }
  }

  Widget quetoContainer(BuildContext context, String? queto) {
    return Container(
        width: getWidth(context) * 0.9,
        //queto container
        decoration: BoxDecoration(
          color: AppColors.softBack,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Positioned(
                right: 15,
                child: IconButton(
                  icon: Icon(
                    Icons.refresh,
                    size: 20,
                  ),
                  color: Colors.white,
                  onPressed: () {
                    fetchQuote();
                  },
                )),
            Positioned(
              top: 0,
              left: 15,
              child: DropdownButton<String>(
                value: dropdownValue,
                dropdownColor: AppColors.softBack,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                iconSize: 24,
                underline: Container(
                  height: 0,
                  color: AppColors.softBack,
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                    fetchQuote();
                  });
                },
                items: categories.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.toUpperCase()),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "“",
                    style: TextStyle(
                        fontSize: 30,
                        height: 1,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(quote.quote,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          height: 1.2,
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(quote.author,
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
} /*  */
