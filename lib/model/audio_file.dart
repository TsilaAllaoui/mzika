import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:metadata_god/metadata_god.dart';

class AudioFile {
  String path;
  Metadata metadata;

  String? title;
  double? duration;
  String? artist;
  String? album;
  String? albumArtist;
  int? trackNumber;
  int? trackTotal;
  int? discNumber;
  int? discTotal;
  int? year;
  String? genre;
  Image? picture;
  int? fileSize;

  AudioFile({required this.path, required this.metadata}) {
    title = metadata.title ?? "";
    duration = metadata.durationMs ?? 0;
    artist = metadata.artist ?? "";
    album = metadata.album ?? "";
    albumArtist = metadata.albumArtist ?? "";
    trackNumber = metadata.trackNumber ?? 0;
    trackTotal = metadata.trackTotal ?? 0;
    discNumber = metadata.discNumber ?? 0;
    discTotal = metadata.discTotal ?? 0;
    year = metadata.year ?? 0;
    genre = metadata.genre ?? "";
    picture =
        metadata.picture == null ? null : Image.memory(metadata.picture!.data);
    fileSize = metadata.fileSize ?? 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'path': path,
      'title': title,
      'duration': duration,
      'artist': artist,
      'album': album,
      'album_artist': albumArtist,
      'track_number': trackNumber,
      'track_total': trackTotal,
      'disc_number': discNumber,
      'disc_total': discTotal,
      'year': year,
      'genre': genre,
      'picture': metadata.picture == null
          ? Uint8List(0).toList()
          : metadata.picture!.data,
      'file_size': fileSize,
    };
  }
}
