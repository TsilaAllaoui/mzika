import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'frontend/mzikaplayer.dart';
import 'frontend/home.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Color.fromARGB(255, 62, 43, 190),
  ));
  runApp(MaterialApp(debugShowCheckedModeBanner: false, routes: {
    '/': (context) => Home(),
    '/player': (context) => MzikaPlayer([], 0),
  }));
}
