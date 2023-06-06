import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayeChangesNotifier extends StateNotifier<AudioPlayer> {
  PlayeChangesNotifier() : super(AudioPlayer());

  void updatePlayer(AudioPlayer player) {
    state = player;
  }
}

final playeChangesProvider =
    StateNotifierProvider<PlayeChangesNotifier, AudioPlayer>(
        (ref) => PlayeChangesNotifier());

class PositionChangesNotifier extends StateNotifier<double> {
  PositionChangesNotifier() : super(10.0);

  void updateCurrentPosition(double p) {
    state = p;
  }
}

final positionChangesProvider =
    StateNotifierProvider<PositionChangesNotifier, double>(
        (ref) => PositionChangesNotifier());
