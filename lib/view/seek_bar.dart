import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mzika/model/audio_file.dart';

import '../controller/providers/player_provider.dart';

class SeekBar extends ConsumerStatefulWidget {
  SeekBar({super.key, required this.audioFile});

  late AudioFile audioFile;

  @override
  ConsumerState<SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends ConsumerState<SeekBar> {
  late AudioFile audiofile;
  late int currentDuration;
  late int totalDuration;

  @override
  void initState() {
    audiofile = widget.audioFile;
    totalDuration = audiofile.duration!.toInt();
    currentDuration = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentDuration = ref.watch(positionChangesProvider).toInt();
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
            value: currentDuration.toDouble(),
            min: 0,
            max: totalDuration.toDouble(),
            onChanged: (double value) {
              ref
                  .read(positionChangesProvider.notifier)
                  .updateCurrentPosition(value);
            },
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
