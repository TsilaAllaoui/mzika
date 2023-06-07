import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mzika/controller/providers/audio_files_provider.dart';
import 'package:mzika/controller/providers/database_provider.dart';
import 'package:mzika/controller/providers/player_provider.dart';
import 'package:mzika/view/now_playing.dart';
import 'package:mzika/view/search_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider_ex2/path_provider_ex2.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:mzika/view/mzikaplayer.dart';
import 'package:mzika/model/audio_file.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() {
    return _HomeState(); //create state
  }
}

class _HomeState extends ConsumerState<Home> {
  // Initial state of the widget
  MzikaPlayer player = MzikaPlayer(const [], 0);
  Database? db;
  String pendingAction = "Scanning storage...";
  late Future pendingFinished;
  String? selectedOptions;
  List<String> options = ["Clear database"];
  TextEditingController searchController = TextEditingController();

  // To insert audio info to db
  Future<void> insertAudioInfo(AudioFile file) async {
    var db = ref.read(databaseProvider);
    await db!.insert("audio_files", file.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Create/Update Db
  Future<bool> updateDb() async {
    setState(() {
      pendingAction = "Scanning storage...";
    });

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

  Future<void> getAudioFilesFromDb() async {
    setState(() {
      pendingAction = "Listing files...";
    });
    List<AudioFile> files = [];
    var entries = await db!.query("audio_files", limit: 100);
    for (final entry in entries) {
      var file = AudioFile.fromMap(map: entry);
      try {
        files.add(file);
      } catch (e) {
        print(file);
      }
    }
    ref.read(audioFilesProvider.notifier).setAudioFiles(files);
    ref.read(allAudioFilesProvider.notifier).setAudioFiles(files);
  }

  // For getting all audio files
  Future<bool> getFilesList() async {
    await updateDb();
    await getAudioFilesFromDb();
    return true;
  }

  @override
  void initState() {
    MetadataGod.initialize();
    pendingFinished = getFilesList();
    player = MzikaPlayer([], 0);
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    db!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var audiofiles = ref.watch(audioFilesProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 235, 235, 235),
            appBar: AppBar(
                title: const Text("Mzika"),
                centerTitle: false,
                backgroundColor: const Color.fromARGB(255, 62, 43, 190),
                actions: [
                  CustomSearchBar(),
                  PopupMenuButton(
                    onSelected: (var choice) async {
                      if (choice == "Clear database") {
                        await ref
                            .read(databaseProvider.notifier)
                            .eraseDatabase();
                        setState(() {
                          pendingFinished = updateDb();
                        });
                        Fluttertoast.showToast(
                          msg: "Database cleared...",
                          gravity: ToastGravity.BOTTOM,
                        );
                      }
                    },
                    padding: EdgeInsets.zero,
                    itemBuilder: (BuildContext context) {
                      return options.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                  ),
                ]),
            body: FutureBuilder(
              future: pendingFinished,
              builder: (context, snapshot) {
                Widget widget = const Text("");

                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    widget = ListView.builder(
                      itemCount: audiofiles.length,
                      itemBuilder: (context, index) {
                        AudioFile currentAudioFile = audiofiles[index];
                        return Card(
                            child: ListTile(
                          subtitle: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  currentAudioFile.artist == null
                                      ? "Unknow Artist"
                                      : currentAudioFile.artist!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                              Text(
                                currentAudioFile.path,
                                maxLines: 1,
                                style: const TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                          title: Text(currentAudioFile.title == null
                              ? currentAudioFile.path
                                  .split('/')
                                  .last
                                  .split('.')
                                  .first
                              : currentAudioFile.title!),
                          leading: Container(
                            margin: const EdgeInsets.all(8),
                            child: currentAudioFile.picture == null
                                ? const Icon(
                                    Icons.audiotrack_outlined,
                                    color: Color.fromARGB(255, 62, 43, 190),
                                    size: 35,
                                  )
                                : ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    child: currentAudioFile.picture,
                                  ),
                          ),
                          trailing: const Icon(
                            Icons.more_vert_outlined,
                            color: Color.fromARGB(255, 61, 46, 135),
                            size: 25,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return NowPlaying(
                                  audiofile: audiofiles[index],
                                );
                              }),
                            );
                          },
                        ));
                      },
                    );
                  } else if (snapshot.hasError) {
                    widget = Text("Error ${snapshot.error}");
                  }
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  widget = Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpinKitCubeGrid(
                        color: pendingAction == "Scanning storage..."
                            ? const Color.fromARGB(255, 62, 43, 190)
                            : Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        pendingAction,
                        style: const TextStyle(fontSize: 15),
                      )
                    ],
                  ));
                }

                return widget;
              },
            )),
      ),
    );
  }
}
