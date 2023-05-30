import 'package:mzika/frontend/colors/colors.dart' as app_color;
import 'package:mzika/backend/player.dart';
import 'package:flutter/material.dart';

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
    player.player.onPositionChanged.listen((Duration d) {
      setState(() {
        if (player.currTime >= player.totalDuration &&
            currMusicIndex < musicList.length) {
          currMusicIndex++;
          player.stopMusic();
          player.playMusic(musicList[currMusicIndex]);
          return;
        }
        List<String> tmp = d.toString().split(".");
        tmp.removeLast();
        player.currTimeString = tmp.last;
        player.currTime = player.parseDuration(player.currTimeString);
      });
    });
  }

  @override
  void initState() {
    musicList = widget.musicList;
    currMusicIndex = widget.index;
    player = widget.player;
    player.playing = true;
    currIcon = Icons.pause_outlined;
    player.playMusic(musicList[currMusicIndex]);
    update();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_color.white,
      appBar: AppBar(
        title: const Text("Player"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
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
            top: 50,
            left: MediaQuery.of(context).size.width / 10,
            right: MediaQuery.of(context).size.width / 10,
            child: Container(
              decoration: BoxDecoration(
                color: app_color.purple,
                borderRadius: BorderRadius.circular(25),
              ),
              height: MediaQuery.of(context).size.height * 0.4,
              child: const Icon(
                Icons.music_note_outlined,
                color: Colors.white,
                size: 150,
              ),
            )),
        Positioned(
          top: MediaQuery.of(context).size.height / 2,
          left: MediaQuery.of(context).size.width / 25,
          // right: MediaQuery.of(context).size.width / 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                musicList[currMusicIndex].split("/").last.split(".mp3").first,
                style: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                textAlign: TextAlign.left,
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
        Positioned(
          top: MediaQuery.of(context).size.height * 0.6,
          left: -10,
          right: -20, // MediaQuery.of(context).size.width / 10,
          child: Column(
            children: [
              Slider(
                  min: 0,
                  max: player.totalDuration,
                  value: player.currTime,
                  activeColor: app_color.purple,
                  inactiveColor: app_color.grey,
                  onChanged: (double n) {
                    setState(() {
                      player.currTime = n;
                      player.player.seek(Duration(seconds: n.toInt()));
                    });
                  }),
              Row(
                children: [
                  const SizedBox(width: 20),
                  Text(
                    player.currTimeString,
                    style: const TextStyle(
                      color: app_color.purple,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width - 120),
                  Text(
                    player.totalDurationString,
                    style: const TextStyle(
                      color: app_color.grey,
                      fontSize: 15,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.68,
          left: 25, //MediaQuery.of(context).size.width / 10,
          right: 35, // MediaQuery.of(context).size.width / 10,
          child: Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      if (currMusicIndex > 0) {
                        setState(() {
                          currMusicIndex--;
                          update();
                          player.stopMusic();
                          player.playMusic(musicList[currMusicIndex]);
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.skip_previous_rounded,
                      color: Colors.grey,
                      size: 50,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        player.currTime =
                            player.currTime - 10 < 0 ? 0 : player.currTime - 10;
                        player.player
                            .seek(Duration(seconds: player.currTime.toInt()));
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
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            player.playing
                                ? player.player.pause()
                                : player.player.resume();
                            player.playing = player.playing ? false : true;
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
                    onPressed: () {
                      setState(() {
                        player.currTime =
                            player.currTime + 10 > player.totalDuration
                                ? player.totalDuration
                                : player.currTime + 10;
                        player.player
                            .seek(Duration(seconds: player.currTime.toInt()));
                      });
                    },
                    icon: const Icon(
                      Icons.fast_forward_rounded,
                      color: Colors.grey,
                      size: 30,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (currMusicIndex < musicList.length) {
                        setState(() {
                          currMusicIndex++;
                          update();
                          player.stopMusic();
                          String a = musicList[currMusicIndex];
                          print("In mzikplayer: $a");
                          player.playMusic(musicList[currMusicIndex]);
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.skip_next_rounded,
                      color: Colors.grey,
                      size: 50,
                    ),
                  ),
                ]),
          ),
        ),
        Positioned(
            top: MediaQuery.of(context).size.height * 0.83,
            left: 10,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      //TODO: Add NightMode
                    },
                    icon: const Icon(
                      Icons.nights_stay_rounded,
                      color: app_color.grey,
                      size: 35,
                    )),
                IconButton(
                    onPressed: () {
                      //TODO: Add Favorite function
                    },
                    icon: const Icon(
                      Icons.favorite_rounded,
                      color: app_color.grey,
                      size: 35,
                    )),
                IconButton(
                    onPressed: () {
                      setState(() {
                        // player.repeat ? player.player.setReleaseMode(ReleaseMode.RELEASE) : player.player.setReleaseMode(ReleaseMode.LOOP);
                        player.repeat = player.repeat ? false : true;
                      });
                    },
                    icon: Icon(
                      Icons.repeat_rounded,
                      color: player.repeat ? app_color.purple : app_color.grey,
                      size: 35,
                    ))
              ],
            )),
      ]),
    );
  }
}
