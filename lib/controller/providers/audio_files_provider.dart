import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mzika/model/audio_file.dart';

class AudioFilesNotifier extends StateNotifier<List<AudioFile>> {
  AudioFilesNotifier() : super([]);

  void setAudioFiles(List<AudioFile> files) {
    state = files;
  }
}

final audioFilesProvider =
    StateNotifierProvider<AudioFilesNotifier, List<AudioFile>>(
        (ref) => AudioFilesNotifier());

class AllAudioFilesNotifier extends StateNotifier<List<AudioFile>> {
  AllAudioFilesNotifier() : super([]);

  void setAudioFiles(List<AudioFile> files) {
    state = files;
  }
}

final allAudioFilesProvider =
    StateNotifierProvider<AllAudioFilesNotifier, List<AudioFile>>(
        (ref) => AllAudioFilesNotifier());
