import 'package:metadata_god/metadata_god.dart';
import 'package:mzika/model/audio_file.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class CustomSearchBar extends StatefulWidget {
  CustomSearchBar({super.key, required this.updateFunction, required this.db});

  void Function(List<AudioFile>) updateFunction;
  Database? db;

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  bool searchEnabled = false;
  TextEditingController textController = TextEditingController();

  Future<void> queryFiltered() async {
    if (widget.db == null) {
      return;
    }
    if (textController.text == "") {
      widget.updateFunction([]);
      return;
    }
    var res = await widget.db!.query("audio_files",
        where: "title LIKE \"%${textController.text}%\"", limit: 100);

    if (res.isEmpty) {
      Metadata meta = const Metadata();
      AudioFile audio = AudioFile(path: "Not Found", metadata: meta);
      widget.updateFunction([audio]);
      return;
    }

    List<AudioFile> files = [];
    for (final file in res) {
      AudioFile audio = AudioFile.fromMap(map: file);
      files.add(audio);
    }
    widget.updateFunction(files);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          searchEnabled = false;
        });
        return false;
      },
      child: !searchEnabled
          ? IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  searchEnabled = !searchEnabled;
                  FocusScope.of(context).unfocus();
                });
              },
            )
          : Row(
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  width: MediaQuery.of(context).size.width / 2,
                  alignment: Alignment.topRight,
                  child: TextField(
                    controller: textController,
                    autofocus: true,
                    cursorColor: Colors.white,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    textInputAction: TextInputAction.search,
                    onEditingComplete: queryFiltered,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: queryFiltered,
                )
              ],
            ),
    );
  }
}
