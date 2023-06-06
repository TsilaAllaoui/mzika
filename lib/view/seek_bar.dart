import 'package:flutter/material.dart';
import 'package:mzika/model/audio_file.dart';

class SeekBar extends StatefulWidget {
  SeekBar({super.key, required this.audioFile});

  late AudioFile audioFile;

  @override
  State<SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  @override
  void initState() {
    audiofile = widget.audioFile;
    currentDuration = 0;
    totalDuration = audiofile.duration!.toInt();
    super.initState();
  }

  late AudioFile audiofile;
  late int currentDuration;
  late int totalDuration;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          Duration(seconds: currentDuration).toString().split('.').first,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        Expanded(
          child: Slider(
            value: totalDuration.toDouble(),
            min: 0,
            max: totalDuration.toDouble(),
            onChanged: (double value) {},
          ),
        ),
        Text(
          Duration(seconds: totalDuration).toString().split('.').first,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
