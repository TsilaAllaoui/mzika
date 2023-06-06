import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mzika/model/audio_file.dart';
import 'package:mzika/view/preview.dart';
import 'package:mzika/view/seek_bar.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:mzika/view/colors/colors.dart' as app_color;

class NowPlaying extends StatefulWidget {
  NowPlaying({super.key, required this.audiofile});
  AudioFile audiofile;

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  AudioFile? audiofile;
  AudioPlayer player = AudioPlayer();

  Future<bool> updateDuration() async {
    var a = await player.setSourceDeviceFile(audiofile!.path);
    var d = await player.getDuration();
    if (d!.inSeconds == 0) {
      print("Error getting duration");
      return false;
    }
    audiofile!.duration = d.inSeconds.toDouble();
    dominantPalette = await getDominantColor();
    return true;
  }

  @override
  void initState() {
    player = AudioPlayer();
    audiofile = widget.audiofile;
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  PaletteGenerator? dominantPalette;

  Future<PaletteGenerator> getDominantColor() async {
    if (audiofile!.picture == null) {
      return PaletteGenerator.fromColors([
        PaletteColor(Colors.white, 1),
      ]);
    }
    return dominantPalette =
        await PaletteGenerator.fromImageProvider(audiofile!.picture!.image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: FutureBuilder(
          future: updateDuration(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return Container(
                padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors:
                        (audiofile!.picture == null || dominantPalette == null)
                            ? const [
                                Color.fromARGB(255, 61, 61, 61),
                                Color.fromARGB(255, 133, 130, 130),
                                Color.fromARGB(255, 202, 195, 195),
                              ]
                            : [...dominantPalette!.colors],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Preview(
                      pochette: audiofile!.picture,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              audiofile!.title!,
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.black),
                            ),
                            Text(
                              audiofile!.artist!,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ]),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SeekBar(audioFile: audiofile!),
                  ],
                ),
              );
            } else {
              return const SpinKitCubeGrid(
                color: app_color.purple,
                size: 20,
              );
            }
          },
        ));
  }
}

// Color.fromARGB(255, 62, 43, 190),
// Color.fromARGB(255, 129, 118, 201),
