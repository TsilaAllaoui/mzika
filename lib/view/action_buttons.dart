import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mzika/controller/providers/player_provider.dart';

class ActionButtons extends ConsumerStatefulWidget {
  const ActionButtons({super.key});

  @override
  ConsumerState<ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends ConsumerState<ActionButtons> {
  late PlayerState playerState;

  @override
  Widget build(BuildContext context) {
    playerState = ref.watch(playerProvider).state;
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
      child: Row(
        children: [
          const Icon(
            Icons.skip_previous_rounded,
            color: Colors.black,
            size: 75,
          ),
          Icon(
            playerState == PlayerState.paused
                ? Icons.pause_circle_outline_outlined
                : Icons.play_arrow_rounded,
            size: 75,
            color: Colors.black,
          ),
          const Icon(
            Icons.skip_next_rounded,
            size: 75,
            color: Colors.black,
          ),
        ],
      ),
    );
    /*return Container(
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.all(0),
      color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.skip_previous_rounded,
              color: Colors.black,
              size: 75,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              playerState == PlayerState.paused
                  ? Icons.pause_circle_outline_outlined
                  : Icons.play_arrow_rounded,
              size: 75,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.skip_next_rounded,
              size: 75,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  */
  }
}
