import 'package:fluttertoast/fluttertoast.dart';
import 'package:mzika/controller/providers/audio_files_provider.dart';
import 'package:mzika/controller/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mzika/model/audio_file.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends ConsumerStatefulWidget {
  CustomSearchBar({super.key});

  @override
  ConsumerState<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends ConsumerState<CustomSearchBar> {
  bool searchEnabled = false;
  TextEditingController textController = TextEditingController();

  Future<void> queryFiltered() async {
    var db = ref.read(databaseProvider);
    if (db == null) {
      return;
    }
    if (textController.text == "") {
      ref
          .read(audioFilesProvider.notifier)
          .setAudioFiles(ref.read(allAudioFilesProvider));
      return;
    }
    var res = await db.query("audio_files",
        where: "title LIKE \"%${textController.text}%\"", limit: 100);

    if (res.isEmpty) {
      ref.read(audioFilesProvider.notifier).setAudioFiles([]);
      Fluttertoast.showToast(
        msg: "No result found",
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    List<AudioFile> files = [];
    for (final file in res) {
      AudioFile audio = AudioFile.fromMap(map: file);
      files.add(audio);
    }
    ref.read(audioFilesProvider.notifier).setAudioFiles(files);

    FocusScope.of(context).unfocus();
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
