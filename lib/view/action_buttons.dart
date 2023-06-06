import 'package:flutter/material.dart';

class ActionButtons extends StatefulWidget {
  const ActionButtons({super.key});

  @override
  State<ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<ActionButtons> {
  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.skip_previous_rounded,
          color: Colors.black,
          size: 75,
        ),
        Icon(
          Icons.pause_circle_outline_sharp,
          size: 75,
          color: Colors.black,
        ),
        Icon(
          Icons.skip_next_rounded,
          size: 75,
          color: Colors.black,
        )
      ],
    );
  }
}
