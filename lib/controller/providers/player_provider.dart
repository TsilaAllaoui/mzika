import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mzika/model/audio_file.dart';

class CurrentAudioFile {
  AudioPlayer? player;
  AudioFile? file;

  CurrentAudioFile({this.player, this.file});
}

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

class PlayerNotifier extends StateNotifier<CurrentAudioFile> {
  PlayerNotifier() : super(CurrentAudioFile());

  void setPlayer(AudioPlayer p) {
    state.player = p;
  }

  void setFile(AudioFile p) {
    state.file = p;
  }

  void toggleFavorite() {
    state.file!.favorite = !state.file!.favorite;
  }
}

final playerProvider = StateNotifierProvider<PlayerNotifier, CurrentAudioFile>(
    (ref) => PlayerNotifier());
