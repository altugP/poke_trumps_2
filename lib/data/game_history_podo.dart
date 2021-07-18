import 'package:flutter/foundation.dart';

class GameHistoryEntry {
  final int id; // SQL INTEGER PRIMARY KEY
  final int playerScore; // SQL INTEGER
  final int opponentScore; // SQL INTEGER
  final bool playerWon; // SQL INTEGER 0(false) 1(true)
  final int setId; // SQL INTEGER
  final int opponentId; // SQL INTEGER

  GameHistoryEntry({
    @required this.id,
    @required this.playerScore,
    @required this.opponentScore,
    @required this.playerWon,
    @required this.setId,
    @required this.opponentId,
  });

  factory GameHistoryEntry.fromMap(Map<String, dynamic> map) {
    var game = GameHistoryEntry(
      id: map["id"],
      playerScore: map["player_score"],
      opponentScore: map["opponent_score"],
      playerWon: map["player_won"] == 0 ? false : true,
      setId: map["set_id"],
      opponentId: map["opponent_id"],
    );
    return game;
  }

  /// Similar to a toJson() function but here
  /// all fields have to match the database's
  /// columns and types.
  Map<String, dynamic> toMap() => {
        "id": id,
        "player_score": playerScore,
        "opponent_score": opponentScore,
        "player_won": playerWon ? 1 : 0,
        "set_id": setId,
        "opponent_id": opponentId,
      };

  @override
  String toString() {
    return toMap().toString();
  }
}
