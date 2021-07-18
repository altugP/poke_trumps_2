import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'game_history_podo.dart';

/// Utility singleton class to allow easy access to database.
class GameHistoryDataBase {
  static final GameHistoryDataBase _instance = GameHistoryDataBase._();
  static Database _database;
  final String databaseTableName = "game_history";

  /// Internal constructor that does nothing but existing.
  ///
  /// I call him Halil.
  GameHistoryDataBase._();

  /// getInstance() method rebranded as a regular constructor.
  factory GameHistoryDataBase() {
    return _instance;
  }

  /// Asynchronous getter field that either directly returns
  /// [_database] or creates it first and then returns it.
  ///
  /// This is usually done in the internal constructor but
  /// we need a getter so why not do this in here.
  Future<Database> get db async {
    if (_database != null) {
      return _database;
    }
    _database = await _init();
    return _database;
  }

  /// Opens database or creates it if it hasn't existed at
  /// the time this was called.
  ///
  /// This is called in [db].
  Future<Database> _init() async {
    final database = openDatabase(
      join(await getDatabasesPath(), "$databaseTableName.db"),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE game_history(id INTEGER PRIMARY KEY, player_score INTEGER, opponent_score INTEGER, player_won INTEGER, set_id INTEGER, opponent_id INTEGER)");
      },
      version: 1,
    );
    return database;
  }

  /// Adds a [game] to the database.
  Future<void> addGameToDB(GameHistoryEntry game) async {
    var client = await db;
    await client.insert(
      databaseTableName,
      game.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Returns a list of [GameHistoryEntry] that are stored in
  /// [_database].
  Future<List<GameHistoryEntry>> fetchGamesFromDB() async {
    var client = await db;
    final List<Map<String, dynamic>> maps =
        await client.query(databaseTableName);
    return List.generate(maps.length, (i) => GameHistoryEntry.fromMap(maps[i]));
  }

  /// Removes a [GameHistoryEntry] with id = [id] from [_database].
  ///
  /// This is SQL injection proof, eventhough that is completely unnecessary.
  Future<void> deleteGame(int id) async {
    var client = await db;
    await client.delete(
      databaseTableName,
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
