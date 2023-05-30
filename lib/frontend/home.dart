import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:file_manager/file_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider_ex2/path_provider_ex2.dart';
import 'package:mzika/frontend/mzikaplayer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState(); //create state
  }
}

class _HomeState extends State<Home> {
  List<String> musicList = [];
  MzikaPlayer player = MzikaPlayer([], 0);
  List<String> files = [];

  void getFilesList() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      Permission.storage.request();
    }
    List<StorageInfo> storageInfo = await PathProviderEx2.getStorageInfo();
    var internaleStoragePath = storageInfo[0].rootDir;
    print("Root Path: $internaleStoragePath");
    Directory dir = Directory(internaleStoragePath);
    List<FileSystemEntity> files_ = dir.listSync(recursive: true, followLinks: false);
    for (var entity in files_)
    {
      String file = entity.toString();
      if (file.contains(".mp3")) {
        file = file.split('/').last;
        files.add(file);
        musicList.add(file);
      }
    }
  }



  void getFiles() async {
    getFilesList();
    setState(() {
    });
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
        backgroundColor: Color.fromARGB(255, 235, 235, 235),
        appBar: AppBar(
          title: Text("Mzika"),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 62, 43, 190),
        ),
        body: files == null
            ? Center(
              child: SpinKitCubeGrid(
                  color: Color.fromARGB(255, 62, 43, 190),
                  size: 20,
                ),
            )
            : ListView.builder(
                itemCount: files?.length ?? 0,
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                    title: Text(files[index]),
                    leading: Icon(
                      Icons.audiotrack_outlined,
                      color: Color.fromARGB(255, 62, 43, 190),
                      size: 40,
                    ),
                    trailing: Icon(
                      Icons.play_arrow,
                      color: Color.fromARGB(255, 61, 46, 135),
                      size: 40,
                    ),
                    onTap: () {
                      player.player.stopMusic();
                      player = MzikaPlayer(musicList, index);
                      //Get.to(Player(""));
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          print(musicList);
                          return player;
                        }),
                      );
                    },
                  ));
                },
              ));
  }
}
