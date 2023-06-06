import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';

class MainPaletteNotifier extends StateNotifier<PaletteGenerator> {
  MainPaletteNotifier() : super(PaletteGenerator.fromColors([]));

  void updateMainPalette(PaletteGenerator palette) {
    state = palette;
  }
}

final mainPaletteProvider =
    StateNotifierProvider<MainPaletteNotifier, PaletteGenerator>(
        (ref) => MainPaletteNotifier());
