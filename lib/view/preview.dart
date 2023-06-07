import 'package:flutter/material.dart';

class Preview extends StatelessWidget {
  Preview({super.key, required this.pochette});

  Image? pochette;

  @override
  Widget build(BuildContext context) {
    if (pochette == null) {
      return Container(
        margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
        width: MediaQuery.of(context).size.width - 20,
        height: MediaQuery.of(context).size.height / 2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Icon(
          Icons.music_note_outlined,
          color: Colors.grey.shade700,
          size: 150,
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          child: SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: Image(
                fit: BoxFit.fill,
                image: pochette!.image,
              )),
        ),
      );
    }
  }
}
