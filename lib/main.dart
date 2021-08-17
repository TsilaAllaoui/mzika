import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'pages/player.dart';
import 'pages/home.dart';

void main() => runApp(MaterialApp(debugShowCheckedModeBanner: false, routes: {
      '/': (context) => Home(),
      '/player': (context) => Player(''),
    }));
