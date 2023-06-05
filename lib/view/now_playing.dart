import 'package:flutter/material.dart';
import 'package:mzika/model/audio_file.dart';

class NowPlaying extends StatefulWidget {
  NowPlaying({super.key, required this.audiofile});
  AudioFile audiofile;

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  AudioFile? audiofile;

  @override
  void initState() {
    audiofile = widget.audiofile;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Now playing"),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width - 20,
              height: MediaQuery.of(context).size.height * 0.45,
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.music_note_outlined,
                color: Colors.white,
                size: 150,
              ),
            ),
            Text(audiofile!.title!)
          ],
        ));
  }
}
