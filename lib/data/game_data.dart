import 'package:flutter/foundation.dart';
import 'package:poke_trumps/data/data.dart';
import 'package:poke_trumps/data/opponent.dart';
import 'package:poke_trumps/data/pokemon_podo.dart';
import 'package:poke_trumps/data/set_podo.dart';
import 'package:poke_trumps/engine/deck_utils.dart' as deckUtils;
import 'package:collection/collection.dart' as collections;

/// Data class to store all game relevant information.
///
/// Stored as [gameData.json] in AppData/UserDocuments
/// on user's device to allow pausing a game by stopping
/// the app.
class GameData {
  bool playerTurn;
  Opponent opponent; // store using id in json
  int playerScore;
  int opponentScore;
  CardSet cardSet; // store using id in json
  List<PokemonCardData> playerDeck;
  List<PokemonCardData> opponentDeck;
  List<PokemonCardData>
      usedCards; // stores all cards already played to allow match history

  // Simple flexible constructor.
  GameData({
    @required this.playerTurn,
    @required this.opponent,
    @required this.playerScore,
    @required this.opponentScore,
    @required this.cardSet,
    @required this.playerDeck,
    @required this.opponentDeck,
    @required this.usedCards,
  });

  /// Constructor that sets up the data one would
  /// expect if the game hasn't started yet.
  GameData.createInitial(
      {@required this.playerTurn,
      @required int opponentId,
      @required int setId}) {
    this.opponent = NoGlobalVariablesHere().opponentList[opponentId];
    this.cardSet = NoGlobalVariablesHere().cardSetList[setId];
    _initData();
  }

  /// Creates a GameData object from a stored json map.
  ///
  /// [json] should be [gameData.json] as described in
  /// [GameData()].
  GameData.fromJson(Map<String, dynamic> json) {
    this.playerTurn = json["player_turn"];
    this.opponent = NoGlobalVariablesHere().opponentList[json["opponent_id"]];
    this.playerScore = json["player_score"];
    this.opponentScore = json["opponent_score"];
    this.cardSet = NoGlobalVariablesHere().cardSetList[json["card_set_id"]];
    this.playerDeck = _getCardsFromJson("player_deck", json);
    this.opponentDeck = _getCardsFromJson("opponent_deck", json);
    this.usedCards = _getCardsFromJson("used_cards", json);
  }

  /// Utility method to retrieve data from ["player_deck"],
  /// ["opponent_deck"] and ["used_cards"] from [gameData.json].
  List<PokemonCardData> _getCardsFromJson(
      String key, Map<String, dynamic> json) {
    var list = json[key];
    var deck = <PokemonCardData>[];
    for (int i = 0; i < list.length; i++) {
      int id = list[i]["id"];
      var card = this.cardSet.cards[id];
      deck.add(card);
    }
    return deck;
  }

  /// Creates data for [GameData.createInitial()].
  ///
  /// Sets scores to 0.
  /// Shuffles cards in [cardSet] and distributes them randomly to the players.
  /// Inits [usedCards] as an empty List.
  void _initData() {
    // initial score should always be 0
    this.playerScore = 0;
    this.opponentScore = 0;

    this.playerDeck = <PokemonCardData>[];
    this.opponentDeck = <PokemonCardData>[];
    // shuffle all cards in the set and distribute them randomly
    var shuffledDeckTmp = deckUtils.shuffle(this.cardSet.cards);
    List<PokemonCardData> shuffledDeck = [];

    // "List<dynamic> != List<PokemonCardData>" and other lies you can tell yourself
    for (int i = 0; i < shuffledDeckTmp.length; i++) {
      shuffledDeck.add(shuffledDeckTmp[i]);
    }

    for (var i = 0; i < shuffledDeck.length; i++) {
      if (i % 2 == 0)
        playerDeck.add(shuffledDeck[i]);
      else
        opponentDeck.add(shuffledDeck[i]);
    }

    // this is always empty at start
    this.usedCards = <PokemonCardData>[];
  }

  /// Creates a json Map of this object.
  ///
  /// Use this to encode to a json file via [dart:convert].
  Map<String, dynamic> toJson() => {
        "player_turn": playerTurn,
        "opponent_id": opponent.id,
        "player_score": playerScore,
        "opponent_score": opponentScore,
        "card_set_id": cardSet.id,
        "player_deck": playerDeck
            .map((card) => {"id": card.id, "set_id": card.setID})
            .toList(),
        "opponent_deck": opponentDeck
            .map((card) => {"id": card.id, "set_id": card.setID})
            .toList(),
        "used_cards": usedCards
            .map((card) => {"id": card.id, "set_id": card.setID})
            .toList()
      };

  @override
  bool operator ==(dynamic other) {
    if (!(other is GameData)) return false;
    if (other.opponent.id != this.opponent.id) return false;
    if (other.playerScore != this.playerScore) return false;
    if (other.opponentScore != this.opponentScore) return false;
    if (other.cardSet.id != this.cardSet.id) return false;
    Function eq = const collections.ListEquality().equals;
    if (!eq(other.playerDeck, this.playerDeck)) return false;
    if (!eq(other.opponentDeck, this.opponentDeck)) return false;
    if (!eq(other.usedCards, this.usedCards)) return false;
    return true;
  }

  @override
  int get hashCode => super.hashCode;
}
