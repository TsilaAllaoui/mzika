import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mzika/view/mzikaplayer.dart';
import 'package:mzika/view/home.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(255, 62, 43, 190),
    ),
  );
  runApp(MaterialApp(debugShowCheckedModeBanner: false, routes: {
    '/': (context) => const Home(),
    '/player': (context) => MzikaPlayer(const [], 0),
  }));
}
