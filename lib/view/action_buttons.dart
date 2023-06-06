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
  Icon middleIcon = const Icon(
    Icons.pause,
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          iconSize: 50,
          onPressed: () {
            ref.read(playerProvider).seek(Duration.zero);
          },
          icon: const Icon(
            Icons.skip_previous_rounded,
            color: Colors.black,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        IconButton(
          iconSize: 100,
          onPressed: () {
            if (ref.read(playerProvider).state == PlayerState.playing) {
              ref.read(playerProvider).pause();
              setState(() {
                middleIcon = const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.black,
                );
              });
            } else if (ref.read(playerProvider).state == PlayerState.paused) {
              ref.read(playerProvider).resume();
              setState(() {
                middleIcon = const Icon(
                  Icons.pause,
                  color: Colors.black,
                );
              });
            }
          },
          icon: middleIcon,
          // icon: ref.read(playerProvider).state == PlayerState.paused
          //     ? const Icon(
          //         Icons.play_arrow_rounded,
          //         color: Colors.black,
          //       )
          //     : const Icon(
          //         Icons.pause,
          //         color: Colors.black,
          //       ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        IconButton(
          iconSize: 50,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Next not yet implemented!"),
                duration: Duration(seconds: 2),
              ),
            );
          },
          icon: const Icon(
            Icons.skip_next_rounded,
            color: Colors.black,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
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
