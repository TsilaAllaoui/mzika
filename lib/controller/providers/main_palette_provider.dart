import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';

class mainPaletteNotifier extends StateNotifier<PaletteGenerator> {
  mainPaletteNotifier() : super(PaletteGenerator.fromColors([]));

  void updateMainPalette(PaletteGenerator palette) {
    state = palette;
  }
}

final mainPaletteProvider =
    StateNotifierProvider((ref) => mainPaletteNotifier());
