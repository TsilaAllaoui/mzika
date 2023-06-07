import 'dart:core';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mzika/model/audio_file.dart';
import 'package:sqflite/sqflite.dart';

class CardModel {
  String name;
  Image image;
  CardModel(this.name, this.image);
}

class CategoriesModel {
  CategoriesModel(this.albums);
  List<CardModel> albums = [];
}

class CategoryNotifier extends StateNotifier<CategoriesModel> {
  CategoryNotifier() : super(CategoriesModel([]));

  Future<bool> setCategories(Database db) async {
    var res = await db.query("audio_files", distinct: true, columns: ["album"]);
    state.albums = [];
    for (dynamic album in res) {
      var sample = await db.query("audio_files",
          where: "album == \"${album['album']}\"", limit: 1);
      AudioFile file = AudioFile.fromMap(map: sample.toList().first);
      Image? image = file.picture;
      if (file.picture == null) {
        image = Image.network("");
      }
      state.albums.add(CardModel(album["album"], image!));
    }
    return true;
  }
}

final categoriesProvider =
    StateNotifierProvider<CategoryNotifier, CategoriesModel>(
        (ref) => CategoryNotifier());
