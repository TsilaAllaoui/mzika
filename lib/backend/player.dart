import 'package:audioplayers/audioplayers.dart';

class Player {
  String filename = "";
  AudioPlayer player = AudioPlayer();
  bool playing = false;
  bool repeat = false;
  String currTimeString = "0:00:00";
  double currTime = 0;
  String totalDurationString = "0:00:00";
  double totalDuration = 0;

  Player(this.filename);//constructor

  void stopMusic() {
    player.stop();
  }

  void playMusic(String _filename) {
    filename = _filename;
    // player.play(filename, isLocal: true);
  }

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
}
