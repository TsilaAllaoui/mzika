import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mzika/frontend/mzikaplayer.dart';
import 'package:mzika/frontend/home.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(255, 62, 43, 190),
    ),
  );
  runApp(
      MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (context) => Home(),
            '/player': (context) => MzikaPlayer([], 0),
  }));
}
