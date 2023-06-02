import 'dart:io';
import 'package:metadata_god/metadata_god.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mzika/frontend/mzikaplayer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider_ex2/path_provider_ex2.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioFile {
  String path = "";
  Metadata metadata = const Metadata();
  AudioFile(this.path, this.metadata);
}

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
  List<AudioFile> audiofiles = [];

  // For getting all audio files
  Future<bool> getFilesList() async {
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
      if (file.lastIndexOf('.') == -1) continue;
      String extension = file.substring(file.lastIndexOf('.'));
      if (extension == ".mp3") {
        try {
          var meta = await MetadataGod.readMetadata(file: file);
          audiofiles.add(AudioFile(file, meta));
        }
        // ignore: empty_catches
        catch (e) {
          e.printError();
        }

        musicList.add(file);
        print(file);
        file = file.split('/').last;
        files.add(file);
      }
    }

    return true;
  }

  // // Get audio files and update state
  // void getFiles() async {
  //   getFilesList();
  //   setState(() {});
  // }

  @override
  void initState() {
    // getFiles();
    MetadataGod.initialize();
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
        body: FutureBuilder(
          future: getFilesList(),
          builder: (context, snapshot) {
            Widget widget = const Text("");

            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                widget = ListView.builder(
                  itemCount: audiofiles.length,
                  itemBuilder: (context, index) {
                    Metadata currentMeta = audiofiles[index].metadata;
                    String currentPath = audiofiles[index].path;

                    return Card(
                        child: ListTile(
                      subtitle: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              currentMeta.artist == null
                                  ? "Unknow Artist"
                                  : currentMeta.artist!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          Text(
                            audiofiles[index].path,
                            maxLines: 1,
                            style: const TextStyle(fontSize: 12),
                          )
                        ],
                      ),
                      title: Text(audiofiles[index].metadata.title == null
                          ? audiofiles[index]
                              .path
                              .split('/')
                              .last
                              .split('.')
                              .first
                          : audiofiles[index]
                              .metadata
                              .title!), //musics[index].title!),
                      leading: audiofiles[index].metadata.picture == null
                          ? const Icon(
                              Icons.audiotrack_outlined,
                              color: Color.fromARGB(255, 62, 43, 190),
                              size: 35,
                            )
                          : Container(
                              margin: const EdgeInsets.all(8),
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                child: Image.memory(
                                    audiofiles[index].metadata.picture!.data),
                              ),
                            ),
                      trailing: const Icon(
                        Icons.more_vert_outlined,
                        color: Color.fromARGB(255, 61, 46, 135),
                        size: 25,
                      ),
                      onTap: () {
                        // player.player.stopMusic();
                        // player = MzikaPlayer(musicList, index);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) {
                        //     return player;
                        //   }),
                        // );
                      },
                    ));
                  },
                );
              } else if (snapshot.hasError) {
                widget = Text("Error ${snapshot.error}");
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              widget = const Center(
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
              ));
            }

            return widget;
          },
        ));
  }
}
