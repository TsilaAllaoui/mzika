import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:mzika/frontend/mzikaplayer.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState(); //create state
  }
}

class _HomeState extends State<Home> {
  List<String> musicList = [];
  MzikaPlayer player = MzikaPlayer([], 0);
  var files;
  void getFiles() async {
    if (await Permission.storage.status.isDenied)
      await Permission.storage.request();

    List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
    String root = storageInfo[0].rootDir;
    var fm = FileManager(root: Directory(root)); //
    files = await fm.filesTree(extensions: ['mp3'] //list only mp3 files
        );
    if (files != null) {
      for (int i = 0; i < files.length; i++) {
        String tmp = await files[i].path;
        musicList.add(tmp);
        print(musicList[i]);
      }
    }
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
                  size: 400,
                ),
            )
            : ListView.builder(
                itemCount: files?.length ?? 0,
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                    title: Text(files[index].path.split('/').last),
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
