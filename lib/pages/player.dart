import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:mzika/colors/colors.dart' as AppColor;

class Player extends StatefulWidget {
  String filename = '';
  AudioPlayer player = AudioPlayer();

  Player(this.filename); //constructor

  void stopMusic() {
    player.stop();
  }

  void playMusic() {
    player.play(filename, isLocal: true);
  }

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  bool playing = false;
  IconData currIcon = Icons.play_arrow_outlined;
  String currTimeString = "0:00:00";
  double currTime = 0;
  String totalDurationString = "0:00:00";
  double totalDuration = 0;

  double parseDuration(String s) {
    double hours = 0;
    double minutes = 0;
    double seconds;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = double.parse(parts[parts.length - 3]) * 120;
    }
    if (parts.length > 1) {
      minutes = double.parse(parts[parts.length - 2]) * 60;
    }
    seconds = (double.parse(parts[parts.length - 1]));
    return hours + minutes + seconds;
  }

  @override
  void initState() {
    playing = true;
    currIcon = Icons.pause_outlined;
    widget.player.play(widget.filename, isLocal: true);
    widget.player.onDurationChanged.listen((Duration d) {
      setState(() {
        List<String> tmp = d.toString().split(".");
        tmp.removeLast();
        totalDurationString = tmp.last;
        totalDuration = parseDuration(totalDurationString);
      });
    });
    widget.player.onAudioPositionChanged.listen((Duration d) {
      setState(() {
        List<String> tmp = d.toString().split(".");
        tmp.removeLast();
        currTimeString = tmp.last;
        currTime = parseDuration(currTimeString);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.White,
      appBar: AppBar(
        title: Text("Player"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            widget.stopMusic();
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColor.Grey,
            size: 35,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              //TODO: Add search function
            },
            icon: Icon(
              Icons.bookmark_border_outlined,
              color: AppColor.Grey,
              size: 35,
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 3),
            child: IconButton(
              onPressed: () {
                //TODO: Add menu function
              },
              icon: Icon(
                Icons.menu,
                color: AppColor.Grey,
                size: 40,
              ),
            ),
          )
        ],
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(children: [
          Container(
            child: Icon(
              Icons.music_note_outlined,
              color: Colors.white,
              size: 150,
            ),
            decoration: BoxDecoration(
              color: AppColor.Purple,
              borderRadius: BorderRadius.circular(25),
            ),
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width - 50,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Center(
              child: Column(
            children: [
              Text(
                widget.filename.split("/").last,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Text(
                "No Artist - Composer",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )),
          Column(
            children: [
              Slider(
                  min: 0,
                  max: totalDuration,
                  value: currTime,
                  activeColor: AppColor.Purple,
                  inactiveColor: AppColor.Grey,
                  onChanged: (double n) {
                    setState(() {
                      currTime = n;
                      widget.player.seek(Duration(seconds: n.toInt()));
                    });
                  }),
              Row(
                children: [
                  SizedBox(width: 20),
                  Text(
                    currTimeString,
                    style: TextStyle(
                      color: AppColor.Purple,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width - 120),
                  Text(
                    totalDurationString,
                    style: TextStyle(
                      color: AppColor.Grey,
                      fontSize: 15,
                    ),
                  ),
                ],
              )
            ],
          ),
          Expanded(
            child: Container(
              //padding: EdgeInsets.only(bottom: 70),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.skip_previous_rounded,
                        color: Colors.grey,
                        size: 50,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.fast_rewind_rounded,
                        color: Colors.grey,
                        size: 30,
                      ),
                    ),
                    Transform.rotate(
                      angle: 150,
                      child: Container(
                        child: IconButton(
                          color: Colors.white,
                          onPressed: () {
                            setState(() {
                              if (!playing)
                                widget.playMusic();
                              else
                                widget.player.pause();
                              playing = playing ? false : true;
                              currIcon = playing
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
                        decoration: BoxDecoration(
                          color: AppColor.Purple,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.height * 0.1,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.fast_forward_rounded,
                        color: Colors.grey,
                        size: 30,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.skip_next_rounded,
                        color: Colors.grey,
                        size: 50,
                      ),
                    ),
                  ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              bottom: 15,
              right: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      //TODO: Add NightMode
                    },
                    icon: Icon(
                      Icons.nights_stay_rounded,
                      color: AppColor.Grey,
                      size: 35,
                    )),
                IconButton(
                    onPressed: () {
                      //TODO: Add Favorite function
                    },
                    icon: Icon(
                      Icons.favorite_rounded,
                      color: AppColor.Grey,
                      size: 35,
                    )),
                IconButton(
                    onPressed: () {
                      //TODO: Add repeat function
                    },
                    icon: Icon(
                      Icons.repeat_rounded,
                      color: AppColor.Grey,
                      size: 35,
                    ))
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
