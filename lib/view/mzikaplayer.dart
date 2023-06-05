
import 'package:audioplayers/audioplayers.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mzika/view/colors/colors.dart' as app_color;
import 'package:mzika/controller/player.dart';
import 'package:flutter/material.dart';

enum repeateState { off, one, all }

// ignore: must_be_immutable
class MzikaPlayer extends StatefulWidget {
  int index = 0;
  List<String> musicList = [];
  Player player = Player("");

  MzikaPlayer(this.musicList, this.index, {super.key});

  @override
  State<MzikaPlayer> createState() => _MzikaPlayerState();
}

class _MzikaPlayerState extends State<MzikaPlayer> {
  //Initial state
  List<String> musicList = [];
  Player player = Player("");
  IconData currIcon = Icons.pause_outlined;
  int currMusicIndex = 0;
  var repeatStatus = repeateState.off;
  bool randomOn = false;
  Metadata metadata = const Metadata();

  late Future<Metadata> futureFunction = getMetadata();

  // Icons
  IconData repeatIcon = Icons.repeat_outlined;
  IconData randomIcon = Icons.shuffle_outlined;

  // To update Slider and time on change
  void update() {
    player.player.onDurationChanged.listen((Duration d) {
      setState(() {
        List<String> tmp = d.toString().split(".");
        tmp.removeLast();
        player.totalDurationString = tmp.last;
        player.totalDuration = player.parseDuration(player.totalDurationString);
      });
    });
    player.player.onPositionChanged.listen((Duration d) async {
      if (player.currTime >= player.totalDuration - 1) {
        if (currMusicIndex < musicList.length - 1) {
          await player.setSource(musicList[currMusicIndex]);
          setState(() {
            currMusicIndex++;
            player.resetMusic();
            player.playMusic();
          });
          return;
        }
        if (currMusicIndex == musicList.length - 1) {
          setState(() {
            player.playing = false;
            currIcon = Icons.play_arrow_rounded;
            player.resetMusic();
            print('LAST************');
            return;
          });
        }
        player.resetMusic();
      }
      setState(() {
        List<String> tmp = d.toString().split(".");
        tmp.removeLast();
        player.currTimeString = tmp.last;
        player.currTime = player.parseDuration(player.currTimeString);
      });
    });
// player.player.onPlayerComplete.listen((event) {
//
// });
  }

// To change random mode
  void toggleRandom() {
    setState(() {
      randomIcon =
          randomOn ? Icons.shuffle_on_outlined : Icons.shuffle_outlined;
      randomOn = !randomOn;
    });
  }

// To change repeat mode
  void toggleRepeat() {
    setState(() {
      if (repeatStatus == repeateState.off) {
        repeatIcon = Icons.repeat_one_on_outlined;
        repeatStatus = repeateState.one;
        player.player.setReleaseMode(ReleaseMode.loop);
      } else if (repeatStatus == repeateState.one) {
        repeatIcon = Icons.repeat_on_outlined;
        repeatStatus = repeateState.all;
        player.player.setReleaseMode(ReleaseMode.loop);
      } else {
        repeatIcon = Icons.repeat_outlined;
        repeatStatus = repeateState.off;
        player.player.setReleaseMode(ReleaseMode.stop);
      }
    });
  }

  Future<Metadata> getMetadata() async {
    player.filename = musicList[currMusicIndex];
    // metadata = await MetadataRetriever.fromFile(File(player.filename));
    // String? trackName = metadata.trackName;
    // player.trackName = trackName ??
    //     musicList[currMusicIndex].split("/").last.split(".mp3").first;
    return Metadata();
  }

  @override
  void initState() {
    // var meta = MetadataRetriever.fromFile(File(musicList[currMusicIndex])).then((value) =>
    // player.trackName = value.trackName! );

    currMusicIndex = widget.index;
    musicList = widget.musicList;
    player.filename = musicList[currMusicIndex];
    player = widget.player;
    player.playing = true;
    currIcon = Icons.pause_outlined;
    player.setSource(musicList[currMusicIndex]);
    player.playMusic();
    update();

    futureFunction = getMetadata();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureFunction,
        builder: (context, snapshot) {
          Widget widget = const Text("");
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              widget = WillPopScope(
                onWillPop: () {
                  player.player.stop();
                  player.player.release();
                  Navigator.pop(context);
                  return Future.value(false);
                },
                child: Scaffold(
                  backgroundColor: app_color.white,
                  appBar: AppBar(
                    title: const Text("Player"),
                    centerTitle: true,
                    leading: IconButton(
                      onPressed: () {
                        player.player.stop();
                        player.player.release();
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_outlined,
                        color: Color.fromARGB(255, 0, 0, 0),
                        size: 35,
                      ),
                    ),
                    actions: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                        height: 50,
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.black,
                          size: 35,
                        ),
                      )
                    ],
                    backgroundColor: Colors.white,
                    elevation: 0.0,
                  ),
                  body: Stack(children: [
                    Positioned(
                        top: 10,
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width - 20,
                          height: MediaQuery.of(context).size.height * 0.45,
                          decoration: BoxDecoration(
                            color: app_color.purple,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Icon(
                            Icons.music_note_outlined,
                            color: Colors.white,
                            size: 150,
                          ),
                        )),
                    Positioned(
                      top: MediaQuery.of(context).size.height / 2,
                      left: 10,
                      child: Align(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              player.trackName,
                              style: const TextStyle(
                                  fontSize: 27,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            const Text(
                              "No Artist - Composer",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 14, 13, 13),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.6,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Slider(
                              min: 0,
                              max: player.totalDuration + 1,
                              value: player.currTime,
                              activeColor: app_color.purple,
                              inactiveColor: app_color.grey,
                              onChanged: (double n) {
                                setState(() {
                                  player.currTime = n;
                                  player.player
                                      .seek(Duration(seconds: n.toInt()));
                                  Duration d = Duration(seconds: n.toInt());
                                  player.currTimeString =
                                      d.toString().split('.').first;
                                });
                              }),
                          Container(
                            margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  player.currTimeString,
                                  style: const TextStyle(
                                    color: app_color.purple,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  player.totalDurationString,
                                  style: const TextStyle(
                                    color: app_color.grey,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.68,
                      left: 25, //MediaQuery.of(context).size.width / 10,
                      right: 35, // MediaQuery.of(context).size.width / 10,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              splashColor: Colors.transparent,
                              onPressed: () {
                                if (currMusicIndex > 0) {
                                  setState(() {
                                    currMusicIndex--;
                                    update();
                                    player.stopMusic();
                                    player.setSource(musicList[currMusicIndex]);
                                    player.playMusic();
                                  });
                                }
                              },
                              icon: Icon(
                                Icons.skip_previous_rounded,
                                color: (currMusicIndex != 0)
                                    ? Colors.black
                                    : Colors.grey.shade400,
                                size: 50,
                              ),
                            ),
                            IconButton(
                              splashColor: Colors.transparent,
                              onPressed: () {
                                setState(() {
                                  player.currTime = player.currTime - 10 < 0
                                      ? 0
                                      : player.currTime - 10;
                                  player.player.seek(Duration(
                                      seconds: player.currTime.toInt()));
                                });
                              },
                              icon: const Icon(
                                Icons.fast_rewind_rounded,
                                color: Colors.grey,
                                size: 30,
                              ),
                            ),
                            Transform.rotate(
                              angle: 150,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: app_color.purple,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                height: 75,
                                width: 75,
                                child: IconButton(
                                  splashColor: Colors.transparent,
                                  color: Colors.white,
                                  onPressed: () {
                                    setState(() {
                                      player.playing
                                          ? player.player.pause()
                                          : player.player.resume();
                                      player.playing =
                                          player.playing ? false : true;
                                      currIcon = player.playing
                                          ? Icons.pause_rounded
                                          : Icons.play_arrow_rounded;
                                    });
                                  },
                                  icon: Transform.rotate(
                                      angle: -150,
                                      child: Icon(
                                        currIcon,
                                      )),
                                  iconSize: 60,
                                ),
                              ),
                            ),
                            IconButton(
                              splashColor: Colors.transparent,
                              onPressed: () {
                                setState(() {
                                  player.currTime = player.currTime + 10 >
                                          player.totalDuration
                                      ? player.totalDuration
                                      : player.currTime + 10;
                                  player.player.seek(Duration(
                                      seconds: player.currTime.toInt()));
                                });
                              },
                              icon: const Icon(
                                Icons.fast_forward_rounded,
                                color: Colors.grey,
                                size: 30,
                              ),
                            ),
                            IconButton(
                              splashColor: Colors.transparent,
                              onPressed: () {
                                if (currMusicIndex < musicList.length - 1) {
                                  setState(() {
                                    if (currMusicIndex < musicList.length - 1) {
                                      currMusicIndex++;
                                      player
                                          .setSource(musicList[currMusicIndex]);
                                    }
                                    player.resetMusic();
                                    player.playMusic();
                                  });
                                }
                              },
                              icon: Icon(
                                Icons.skip_next_rounded,
                                color: (currMusicIndex != musicList.length - 1)
                                    ? Colors.black
                                    : Colors.grey.shade400,
                                size: 50,
                              ),
                            ),
                          ]),
                    ),
                    Positioned(
                        top: MediaQuery.of(context).size.height * 0.83,
                        left: 10,
                        right: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                splashColor: Colors.transparent,
                                onPressed: () {
                                  //TODO: Add NightMode
                                },
                                icon: const Icon(
                                  Icons.nights_stay_rounded,
                                  color: app_color.grey,
                                  size: 35,
                                )),
                            IconButton(
                                splashColor: Colors.transparent,
                                onPressed: () {
                                  //TODO: Add Favorite function
                                },
                                icon: const Icon(
                                  Icons.favorite_rounded,
                                  color: app_color.grey,
                                  size: 35,
                                )),
                            IconButton(
                                splashColor: Colors.transparent,
                                onPressed: () {
                                  setState(() {
                                    // player.repeat ? player.player.setReleaseMode(ReleaseMode.RELEASE) : player.player.setReleaseMode(ReleaseMode.LOOP);
                                    player.repeat =
                                        player.repeat ? false : true;
                                  });
                                },
                                icon: Icon(
                                  Icons.repeat_rounded,
                                  color: player.repeat
                                      ? app_color.purple
                                      : app_color.grey,
                                  size: 35,
                                ))
                          ],
                        )),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.79,
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              splashColor: Colors.transparent,
                              icon: Icon(
                                repeatIcon,
                                color: Colors.black,
                                size: 35,
                              ),
                              onPressed: toggleRepeat,
                            ),
                            IconButton(
                              splashColor: Colors.transparent,
                              icon: Icon(
                                randomIcon,
                                color: Colors.black,
                                size: 35,
                              ),
                              onPressed: toggleRandom,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              );
            } else if (snapshot.hasError) {
              widget = Text("Error ${snapshot.error}");
              print("Error ${snapshot.error}");
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            widget = const SpinKitCubeGrid(
              color: Color.fromARGB(255, 62, 43, 190),
              size: 20,
            );
          }
          return widget;
        });
  }
}
