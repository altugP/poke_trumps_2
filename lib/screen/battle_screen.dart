import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:poke_trumps/config/app_colors.dart';
import 'package:poke_trumps/config/neumorph.dart';
import 'package:poke_trumps/data/data.dart';
import 'package:poke_trumps/data/game_data.dart';
import 'package:poke_trumps/data/game_history_database.dart';
import 'package:poke_trumps/data/game_history_podo.dart';
import 'package:poke_trumps/data/pokemon_podo.dart';
import 'package:poke_trumps/data/preferences_constants.dart';
import 'package:poke_trumps/engine/battle_engine.dart';
import 'package:poke_trumps/engine/file_utils.dart';
import 'package:poke_trumps/screen/end_screen.dart';
import 'package:poke_trumps/screen/pre_battle_opponent_screen.dart';
import 'package:poke_trumps/screen/pre_battle_player_screen.dart';
import 'package:poke_trumps/widget/transparent_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BattleScreen extends StatelessWidget {
  static final attackValue = 0;
  static final defenseValue = 1;
  static final speedValue = 2;

  final int roundsToWin = 6;

  final AppColors appColors = AppColors();
  final NeumorphConstants neumorph = NeumorphConstants();
  final Logger logger = Logger(printer: PrettyPrinter());

  final String pathToCardBack; // used to pass on to other screen
  final int valueToCompare;
  final bool comingFromPlayer;
  final StatEngine engine;

  BattleScreen._({
    @required this.valueToCompare,
    @required this.comingFromPlayer,
    @required this.pathToCardBack,
    @required this.engine,
  });

  factory BattleScreen({
    @required int valueToCompare,
    @required bool comingFromPlayer,
    @required String pathToCardBack,
  }) {
    var engine = StatEngine(
      playerCard: NoGlobalVariablesHere().gameData.playerDeck.first,
      opponentCard: NoGlobalVariablesHere().gameData.opponentDeck.first,
      valueToCompare: valueToCompare,
    );

    return BattleScreen._(
      valueToCompare: valueToCompare,
      comingFromPlayer: comingFromPlayer,
      pathToCardBack: pathToCardBack,
      engine: engine,
    );
  }

  String _valueName(int value) => value == BattleScreen.attackValue
      ? "Attack"
      : (value == BattleScreen.defenseValue)
          ? "Defense"
          : (value == BattleScreen.speedValue) ? "Speed" : "Error";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: GestureDetector(
        onTap: () {
          _updateGameData(engine.winner);
          _changeScreen(NoGlobalVariablesHere().gameData.playerTurn, context,
              pathToCardBack);
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: neumorph.neumorphColorBackground,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: TransparentAppBar().create(
              Text(
                "Battle in ${_valueName(valueToCompare)}",
                style: TextStyle(
                  fontSize: 24,
                  color: appColors.standardTextColor,
                ),
              ),
            ),
            body: Row(
              children: <Widget>[
                _buildPokemonColumn(
                  context,
                  NoGlobalVariablesHere().gameData.playerDeck.first,
                  true, // player is always on the left
                  (engine.winner != null) &&
                      (engine.winner ==
                          NoGlobalVariablesHere().gameData.playerDeck.first),
                  true, // player
                ),
                _buildPokemonColumn(
                  context,
                  NoGlobalVariablesHere().gameData.opponentDeck.first,
                  false, // opponent is always on the right
                  (engine.winner != null) &&
                      (engine.winner ==
                          NoGlobalVariablesHere().gameData.opponentDeck.first),
                  false, // opponent
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPokemonColumn(BuildContext context, PokemonCardData cardData,
      bool left, bool won, bool player) {
    return Flexible(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                width: (MediaQuery.of(context).size.width / 2) - 20.0,
                decoration: BoxDecoration(
                  color: neumorph.neumorphColorBackground,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: neumorph.neumorphColorDarkShadow,
                      blurRadius: neumorph.neumorphNumberBlurRadius,
                      offset: Offset(
                        neumorph.neumorphNumberUniversalOffset,
                        neumorph.neumorphNumberUniversalOffset,
                      ),
                    ),
                    BoxShadow(
                      color: neumorph.neumorphColorLightShadow,
                      blurRadius: neumorph.neumorphNumberBlurRadius,
                      offset: Offset(
                        -neumorph.neumorphNumberUniversalOffset,
                        -neumorph.neumorphNumberUniversalOffset,
                      ),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      cardData.name,
                      style: TextStyle(
                        color: appColors.standardTextColor,
                        fontSize: 24,
                      ),
                    ),
                    Image.asset(
                      "assets/icon/type/${cardData.typeString.toLowerCase()}.png",
                      width: 24,
                      height: 24,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              _buildCardAnimationContainer(
                context,
                cardData,
                left,
                won,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Value: ${_getValueToCompare(cardData)}",
                style: TextStyle(
                  color: appColors.standardTextColor,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Type Bonus: ${player ? (engine.playerStat - _getValueToCompare(cardData)) : (engine.opponentStat - _getValueToCompare(cardData))}",
                style: TextStyle(
                  color: appColors.standardTextColor,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              Text(
                ">>> ${player ? engine.playerStat : engine.opponentStat} <<<",
                style: TextStyle(
                  color: appColors.standardTextColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          won
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.green,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: neumorph.neumorphNumberBlurRadius,
                          offset: Offset(
                            neumorph.neumorphNumberUniversalOffset,
                            neumorph.neumorphNumberUniversalOffset,
                          ),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "Resulting: Winner",
                          style: TextStyle(
                            color: appColors.standardTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.red,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: neumorph.neumorphNumberBlurRadius,
                          offset: Offset(
                            neumorph.neumorphNumberUniversalOffset,
                            neumorph.neumorphNumberUniversalOffset,
                          ),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "Resulting: Loser",
                          style: TextStyle(
                            color: appColors.standardTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  int _getValueToCompare(PokemonCardData cardData) {
    if (valueToCompare == BattleScreen.attackValue) return cardData.attackValue;
    if (valueToCompare == BattleScreen.defenseValue)
      return cardData.defenseValue;
    if (valueToCompare == BattleScreen.speedValue) return cardData.speedValue;
    return 0;
  }

  Widget _buildCardAnimationContainer(
      BuildContext context, PokemonCardData card, bool left, bool winner) {
    final double padding = 10.0;
    double width = MediaQuery.of(context).size.width / 2;

    var image = !left
        ? Image.asset(card.pathToAnimation)
        : Hero(
            tag: "${card.id}:${card.name}-battle",
            child: Transform(
              transform: Matrix4.identity()..setEntry(0, 0, -1), // mirror
              alignment: FractionalOffset.center,
              child: Image.asset(card.pathToAnimation),
            ),
          );

    return Center(
      child: Container(
        width: width - 2 * padding,
        height: width - 2 * padding,
        decoration: BoxDecoration(
          color: neumorph.neumorphColorBackground,
          boxShadow: [
            BoxShadow(
              color: neumorph.neumorphColorDarkShadow,
              blurRadius: neumorph.neumorphNumberBlurRadius,
              offset: Offset(
                neumorph.neumorphNumberUniversalOffset,
                neumorph.neumorphNumberUniversalOffset,
              ),
            ),
            BoxShadow(
              color: neumorph.neumorphColorLightShadow,
              blurRadius: neumorph.neumorphNumberBlurRadius,
              offset: Offset(
                -neumorph.neumorphNumberUniversalOffset,
                -neumorph.neumorphNumberUniversalOffset,
              ),
            ),
          ],
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Container(
            width: width - 5 * padding,
            height: width - 5 * padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: winner ? Colors.green : Colors.red,
            ),
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: image,
            ),
          ),
        ),
      ),
    );
  }

  /// Shows alert pop up if user wants to go back
  /// to previous screen.
  ///
  /// Sets the [PrefsConstants.gameRunningPrefsKey] field in [SharedPreferences]
  /// to false if succesfully popped.
  Future<bool> _onWillPop(BuildContext context) async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Are you sure?"),
            content: Text(
                "This action will end the game and you will have to start anew. Do you want to proceeed?"),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("No"),
              ),
              FlatButton(
                onPressed: () async {
                  var prefs = await SharedPreferences.getInstance();
                  prefs.setBool(PrefsConstants.gameRunningPrefsKey, false);

                  Navigator.of(context).pop(true);
                },
                child: Text("Yes"),
              ),
            ],
          ),
        )) ??
        false;
  }

  void _updateGameData(PokemonCardData winner) async {
    var gameData = NoGlobalVariablesHere().gameData;

    // update score
    if (winner == gameData.playerDeck.first) {
      // player won
      gameData.playerScore++;
    } else if (winner == gameData.opponentDeck.first) {
      // opponent won
      gameData.opponentScore++;
    }
    // else draw

    // add used cards to [gameData.usedCards]
    gameData.usedCards.add(gameData.playerDeck.first);
    gameData.usedCards.add(gameData.opponentDeck.first);

    // remove top cards from deck
    gameData.opponentDeck.removeAt(0);
    gameData.playerDeck.removeAt(0);

    // if a deck is empty, game ends in win for opponent
    if (gameData.playerDeck.length == 0) {
      // since _changeScreen is called directly after this should suffice
      gameData.opponentScore = 6;
      // both decks are alawys the same size, no need to check for opponents deck length
    }

    // save game state to disk
    await FileUtils().writeGameDataToDisk(gameData);
  }

  void _changeScreen(
      bool playerTurn, BuildContext context, String pathToCardBack) {
    // update gameData
    NoGlobalVariablesHere().gameData.playerTurn = !playerTurn;

    if (NoGlobalVariablesHere().gameData.playerScore >= roundsToWin) {
      // player won
      _setPlayingFlag(false);
      _addGameToDatabase(NoGlobalVariablesHere().gameData, true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          logger.i("Player won. Switching screen");
          return EndScreen(playerWon: true);
        }),
      );
    } else if (NoGlobalVariablesHere().gameData.opponentScore >= roundsToWin) {
      // opponent won
      _setPlayingFlag(false);
      _addGameToDatabase(NoGlobalVariablesHere().gameData, false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          logger.i("Opponent won. Switching screen");
          return EndScreen(playerWon: false);
        }),
      );
    } else {
      // no one won, resuming game
      // change screen according to last turn
      if (playerTurn) {
        // last turn was a player turn
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PreBattleOpponentScreen(
              pathToCardBack: pathToCardBack,
            ),
          ),
        );
      } else {
        // last turn was an opponent turn
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PreBattleUserScreen(
              pathToCardBack: pathToCardBack,
            ),
          ),
        );
      }
    }
  }

  _setPlayingFlag(bool value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(PrefsConstants.gameRunningPrefsKey, value);
  }

  _addGameToDatabase(GameData gameData, bool playerWon) async {
    var dbManager = GameHistoryDataBase();
    var entryList = await dbManager.fetchGamesFromDB();
    var entry = GameHistoryEntry(
      id: entryList.length + 2, // sql index starts at 1
      opponentId: gameData.opponent.id,
      opponentScore: gameData.opponentScore,
      playerScore: gameData.playerScore,
      playerWon: playerWon,
      setId: gameData.cardSet.id,
    );
    await dbManager.addGameToDB(entry);
  }
}
