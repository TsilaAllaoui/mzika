import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:mzika/controller/providers/categories_provider.dart';
import 'package:mzika/controller/providers/database_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_ex2/path_provider_ex2.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

import '../model/audio_file.dart';

class CategoryCard extends ConsumerStatefulWidget {
  CategoryCard(
      {super.key,
      required this.content,
      required this.color,
      required this.image});

  String content;
  Color color;
  Image image;

  @override
  ConsumerState<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends ConsumerState<CategoryCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          image: DecorationImage(image: widget.image.image, fit: BoxFit.fill),
          borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [widget.color, widget.color.withOpacity(0.6)])),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            widget.content,
            maxLines: 1,
            overflow: TextOverflow.fade,
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class Categories extends ConsumerStatefulWidget {
  const Categories({super.key});

  @override
  ConsumerState<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends ConsumerState<Categories> {
  Database? db;
  final _controller = PageController(viewportFraction: 0.7);

// To insert audio info to db
  Future<void> insertAudioInfo(AudioFile file) async {
    var db = ref.read(databaseProvider);
    await db!.insert("audio_files", file.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Create/Update Db
  Future<bool> updateDb() async {
    // Requesting storage permission if not enabled
    var status = await Permission.storage.status;
    if (status.isDenied) {
      await Permission.storage.request();
    }

    // Getting storage list adn root internal directory
    List<StorageInfo> storageInfo = await PathProviderEx2.getStorageInfo();
    var internaleStoragePath = storageInfo[0].rootDir;
    Directory dir = Directory(internaleStoragePath);
    // Getting all files
    List<FileSystemEntity> files_ =
        dir.listSync(recursive: true, followLinks: false);

    // Db directory
    Directory dbDir = await getApplicationDocumentsDirectory();

    // Open/Create db
    db = await openDatabase(
      "${dbDir.path}/database.db",
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE audio_files(id INTEGER PRIMARY KEY, path TEXT, title TEXT, duration INTEGER, artist TEXT, album TEXT, album_artist TEXT, track_number INTEGER, track_total INTEGER, disc_number INTEGER, disc_total INTEGER, year INTEGER, genre TEXT, picture BLOB, file_size INTEGER)",
        );
      },
      version: 1,
    );

    ref.read(databaseProvider.notifier).setDatabase(db!);

    // If db already exist,skipping file rescanning...
    var res = await db!.query("audio_files", limit: 1);
    if (res.isEmpty) {
      var entries = await db!.query("audio_files", limit: 100);
      if (entries.isEmpty) {
        // Filtering by mp3 extension // TODO: add more audio extension support
        for (var entity in files_) {
          String file = entity.path;
          if (file.lastIndexOf('.') == -1) continue;
          String extension = file.substring(file.lastIndexOf('.'));
          if (extension == ".mp3") {
            try {
              var meta = await MetadataGod.readMetadata(file: file);
              AudioFile audiofile = AudioFile(path: file, metadata: meta);
              await insertAudioInfo(audiofile);
            } catch (e) {
              print("File $file not added.");
            }
          }
        }
      } else {
        print(
            "Database already exist at ${dbDir.path}/database.db... Skipping creation...");
      }
    }
    return true;
  }

  Future<bool> getCategories() async {
    await updateDb();
    return await ref.read(categoriesProvider.notifier).setCategories(db!);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Mzika"),
              centerTitle: true,
              backgroundColor: Colors.black,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search_outlined),
                  iconSize: 30,
                )
              ],
            ),
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black, Color.fromARGB(255, 97, 96, 96)]),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: const EdgeInsets.fromLTRB(15, 20, 10, 5),
                      child: const Text(
                        "Albums",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                  FutureBuilder(
                    future: getCategories(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          List<Widget> albumCards = [];
                          var albums = ref.read(categoriesProvider).albums;
                          if (albums.isNotEmpty) {
                            for (final album in albums) {
                              albumCards.add(
                                CategoryCard(
                                  content: album.name,
                                  color: Colors.red,
                                  image: album.image,
                                ),
                              );
                            }
                          }
                          return SizedBox(
                            height: 300,
                            width: double.infinity,
                            child: PageView.builder(
                              controller: _controller,
                              itemCount: albumCards.length,
                              itemBuilder: (context, index) {
                                return albumCards[index];
                              },
                            ),
                          );
                        } else {
                          return const Text("");
                        }
                      } else {
                        return const SizedBox(
                          height: 300,
                          child: Center(
                            child: SpinKitCubeGrid(
                              color: Colors.orange,
                              size: 20,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  Container(
                      margin: const EdgeInsets.fromLTRB(15, 20, 10, 5),
                      child: const Text(
                        "Artists",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                  FutureBuilder(
                    future: getCategories(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          List<Widget> artistCards = [];
                          var artists = ref.read(categoriesProvider).artists;
                          if (artists.isNotEmpty) {
                            for (final artist in artists) {
                              artistCards.add(
                                CategoryCard(
                                  content: artist.name,
                                  color: Colors.blue,
                                  image: artist.image,
                                ),
                              );
                            }
                          }
                          return SizedBox(
                            height: 300,
                            width: double.infinity,
                            child: PageView.builder(
                              controller: _controller,
                              itemCount: artistCards.length,
                              itemBuilder: (context, index) {
                                return artistCards[index];
                              },
                            ),
                          );
                        } else {
                          return const Text("");
                        }
                      } else {
                        return const SizedBox(
                          height: 300,
                          child: Center(
                            child: SpinKitCubeGrid(
                              color: Colors.orange,
                              size: 20,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

/*Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black, Colors.grey]),
          ),
          child: GridView.count(
            crossAxisCount: 2,
            children: [
              CategoryCard(content: "Album", color: Colors.blue),
              CategoryCard(content: "All", color: Colors.red),
              CategoryCard(content: "Rock", color: Colors.yellow),
              CategoryCard(content: "Pop", color: Colors.purple),
              CategoryCard(content: "Classic", color: Colors.green),
              CategoryCard(content: "HipHop", color: Colors.deepPurpleAccent),
            ],
          ),
        ),*/