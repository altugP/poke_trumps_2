import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:poke_trumps/data/game_data.dart';

/// Utility class to read and write to [gameData.json].
class FileUtils {
  final String gameDataFileName = "gameData.json";

  /// Returns the path where the application can store
  /// files under it's OS.
  ///
  /// Returns the path to NSDocumentsDirectory on iOS
  /// and the path to AppData on Android.
  Future<String> get _localPath async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Returns the [File] the [GameData] is stored in.
  Future<File> get _localFile async {
    final String path = await _localPath;
    return File("$path/$gameDataFileName");
  }

  /// Used to write a json representation of [gameData]
  /// to [gameDataFileName].
  ///
  /// Every call deletes the old file and re-creates it.
  Future<File> writeGameDataToDisk(GameData gameData) async {
    final File file = await _localFile;

    String gameDataString = jsonEncode(gameData.toJson());
    return file.writeAsString(gameDataString);
  }

  /// Creates a [GameData] object with contents specified
  /// in [gameDataFileName].
  Future<GameData> readGameDataFromDisk() async {
    try {
      final File file = await _localFile;

      String fileContents = await file.readAsString();

      return GameData.fromJson(jsonDecode(fileContents));
    } catch (e) {
      return null; // only happens if file was empty when this was called
    }
  }
}
