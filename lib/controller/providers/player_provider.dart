import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PositionChangesNotifier extends StateNotifier<double> {
  PositionChangesNotifier() : super(10.0);

  void updateCurrentPosition(double p) {
    state = p;
  }
}

final positionChangesProvider =
    StateNotifierProvider<PositionChangesNotifier, double>(
        (ref) => PositionChangesNotifier());

class SeekNotifier extends StateNotifier<double> {
  SeekNotifier() : super(10.0);

  void seekPosition(double p) {
    state = p;
  }
}

final seekProvider =
    StateNotifierProvider<SeekNotifier, double>((ref) => SeekNotifier());

class PlayerNotifier extends StateNotifier<AudioPlayer> {
  PlayerNotifier() : super(AudioPlayer());

  void setPlayer(AudioPlayer p) {
    state = p;
  }
}

final playerProvider = StateNotifierProvider<PlayerNotifier, AudioPlayer>(
    (ref) => PlayerNotifier());
