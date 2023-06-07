import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseNotifier extends StateNotifier<Database?> {
  DatabaseNotifier() : super(null);

  void setDatabase(Database db) {
    state = db;
  }

  Future<void> eraseDatabase() async {
    // Db directory
    Directory dbDir = await getApplicationDocumentsDirectory();

    var filesInDbDir = dbDir.listSync(recursive: true, followLinks: false);
    for (final element in filesInDbDir) {
      if (element.path.split("/").last == "database.db") {
        var res = await element.delete();
        print("Database deleted at : ${element.path}...$res");
      }
    }
    state = null;
  }
}

final databaseProvider = StateNotifierProvider<DatabaseNotifier, Database?>(
    (ref) => DatabaseNotifier());
