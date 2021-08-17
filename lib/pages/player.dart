import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

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
  String currTime = "0:00:00";
  String totalDuration = "0:00:00";

  @override
  void initState() {
    playing = true;
    currIcon = Icons.pause_outlined;
    //widget.player.play(widget.filename, isLocal: true);
    widget.player.onDurationChanged.listen((Duration d) {
      setState(() {
        List<String> tmp = d.toString().split(".");
        tmp.removeLast();
        totalDuration = tmp.last;
      });
      //widget.player.stop();
    });
    widget.player.onAudioPositionChanged.listen((Duration d) {
      setState(() {
        List<String> tmp = d.toString().split(".");
        tmp.removeLast();
        currTime = tmp.last;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            color: Color.fromARGB(255, 187, 187, 191),
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
              color: Color.fromARGB(255, 187, 187, 191),
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
                color: Colors.red,
              ),
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
                color: Color.fromARGB(255, 61, 46, 135),
                borderRadius: BorderRadius.circular(25),
              ),
              height: MediaQuery.of(context).size.height * 0.4,
            )),
        Positioned(
          top: MediaQuery.of(context).size.height / 2,
          left: MediaQuery.of(context).size.width / 10,
          right: MediaQuery.of(context).size.width / 10,
          child: Center(
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
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.65,
          left: 25, //MediaQuery.of(context).size.width / 10,
          right: 35, // MediaQuery.of(context).size.width / 10,
          child: Center(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.skip_previous_outlined,
                      color: Colors.black,
                      size: 50,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.deepPurple,
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            if (!playing)
                              widget.playMusic();
                            else
                              widget.player.pause();
                            playing = playing ? false : true;
                            currIcon = playing
                                ? Icons.pause_outlined
                                : Icons.play_arrow_outlined;
                          });
                        },
                        iconSize: 100,
                        icon: Icon(
                          currIcon,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.skip_next_outlined,
                      color: Colors.black,
                      size: 50,
                    ),
                  ),
                ]),
          ),
        ),
      ]),
    );
  }
}

/*body: Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.87,
          child: Container(
            color: Colors.black87,
          ),
        ),
        Positioned(
          top: 100,
          left: 50,
          right: 50,
          child: Center(
            child: Text(
              "${widget.filename.split('/').last}",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          top: 150,
          left: 20,
          right: 20,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Icon(
              Icons.music_note_outlined,
              color: Colors.black,
              size: 200,
            ),
          ),
        ),
        Positioned(
            top: MediaQuery.of(context).size.height * 0.76,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$currTime | $totalDuration',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    )),
              ],
            )),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.85,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.15,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.85,
          left: 0,
          right: 15,
          child: Center(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.skip_previous_outlined,
                      color: Colors.black,
                      size: 50,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          if (!playing)
                            widget.playMusic();
                          else
                            widget.player.pause();
                          playing = playing ? false : true;
                          currIcon = playing
                              ? Icons.pause_outlined
                              : Icons.play_arrow_outlined;
                        });
                      },
                      iconSize: 100,
                      icon: Icon(
                        currIcon,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.skip_next_outlined,
                      color: Colors.black,
                      size: 50,
                    ),
                  ),
                ]),
          ),
        ),
      ],
    )*/
