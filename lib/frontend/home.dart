import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mzika/frontend/mzikaplayer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider_ex2/path_provider_ex2.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() {
    return _HomeState(); //create state
  }
}

class _HomeState extends State<Home> {
  // Initial state of the widget
  List<String> musicList = [];
  MzikaPlayer player = MzikaPlayer(const [], 0);
  List<String> files = [];

  // For getting all audio files
  void getFilesList() async {
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

    // Filtering by mp3 extension // TODO: add more audio extension support
    for (var entity in files_) {
      String file = entity.path;
      if (file.contains(".mp3")) {
        musicList.add(file);
        print(file);
        file = file.split('/').last;
        files.add(file);
      }
    }
  }

  // Get audio files and update state
  void getFiles() async {
    getFilesList();
    setState(() {});
  }

  @override
  void initState() {
    getFiles();
    player = MzikaPlayer(musicList, 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 235, 235, 235),
        appBar: AppBar(
          title: const Text("Mzika"),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 62, 43, 190),
        ),
        body: files.isEmpty
            ? const Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitCubeGrid(
                    color: Color.fromARGB(255, 62, 43, 190),
                    size: 20,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Scanning storage...",
                    style: TextStyle(fontSize: 15),
                  )
                ],
              ))
            : ListView.builder(
                itemCount: files.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                    title: Text(files[index]),
                    leading: const Icon(
                      Icons.audiotrack_outlined,
                      color: Color.fromARGB(255, 62, 43, 190),
                      size: 40,
                    ),
                    trailing: const Icon(
                      Icons.play_arrow,
                      color: Color.fromARGB(255, 61, 46, 135),
                      size: 40,
                    ),
                    onTap: () {
                      MetadataRetriever.fromFile(File(musicList[index])).then((value) => {
                    print(value);
                    player.player.stopMusic();
                  player = MzikaPlayer(musicList, index);
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                  return player;
                  }),
                  );
                      });
                    }

                    },
                  ));
                },
              ));
  }
}
