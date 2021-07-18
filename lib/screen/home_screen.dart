import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:poke_trumps/config/app_colors.dart';
import 'package:poke_trumps/config/neumorph.dart';
import 'package:poke_trumps/data/data.dart';
import 'package:poke_trumps/data/game_history_database.dart';
import 'package:poke_trumps/data/preferences_constants.dart';
import 'package:poke_trumps/engine/file_utils.dart';
import 'package:poke_trumps/screen/game_history_screen.dart';
import 'package:poke_trumps/screen/opponent_screen.dart';
import 'package:poke_trumps/screen/opponent_selection_screen.dart';
import 'package:poke_trumps/screen/pokedex_screen.dart';
import 'package:poke_trumps/screen/pre_battle_opponent_screen.dart';
import 'package:poke_trumps/screen/pre_battle_player_screen.dart';
import 'package:poke_trumps/screen/settings_screen.dart';
import 'package:poke_trumps/widget/home_screen_play_button.dart';
import 'package:poke_trumps/widget/home_screen_secondary_button.dart';
import 'package:poke_trumps/widget/transparent_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This is the home screen of the application. It hosts
/// a play button, a pokédex button and an opponents button
/// as well as a settings button in the AppBar.
class HomeScreen extends StatelessWidget {
  final Logger logger = Logger(printer: PrettyPrinter());
  // color settings
  final AppColors appColors = AppColors();
  final NeumorphConstants neumorph = NeumorphConstants();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: neumorph.neumorphColorBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: TransparentAppBar().create(
          Text(
            "PokéTrumps",
            style: TextStyle(
              color: appColors.standardTextColor,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            PopupMenuButton(
              color: neumorph.neumorphColorBackground,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.settings,
                        color: appColors.standardTextColor,
                      ),
                      SizedBox(width: 15),
                      Text(
                        "Settings",
                        style: TextStyle(
                          color: appColors.standardTextColor,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.storage,
                        color: appColors.standardTextColor,
                      ),
                      SizedBox(width: 15),
                      Text(
                        "Match History",
                        style: TextStyle(
                          color: appColors.standardTextColor,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 0) {
                  _settingsButtonFunction(context);
                } else if (value == 1) {
                  _showMatchHistory(context);
                }
              },
            ),
          ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: neumorph.neumorphColorBackground,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                PlayButton(onTap: () => _playButtonFunction(context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SecondaryButton(
                      onTap: () => _pokedexButtonFunction(context),
                      pathToImage: "assets/icon/pokedex.png",
                      text: "Pokédex",
                    ),
                    SecondaryButton(
                      onTap: () => _opponentsButtonFunction(context),
                      pathToImage: "assets/icon/boulder_badge.png",
                      text: "Opponents",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Functionality of the play button.
  ///
  /// [context] is required to change the active
  /// screen via [Navigator.push].
  _playButtonFunction(BuildContext context) async {
    logger.i("Play Button tapped -> Loading User Defaults");

    var prefs = await SharedPreferences.getInstance();
    var setId = prefs.getInt(PrefsConstants.cardSetPrefsKey) ?? 0;
    var pathToCardBack = prefs.getString(PrefsConstants.cardSleevePrefsKey) ??
        "assets/img/sleeve/card_sleeve_basic.png";
    var running = prefs.getBool(PrefsConstants.gameRunningPrefsKey) ?? false;

    logger.i("Loaded set id User Defaults -> Checking if game was active");
    if (!running) {
      logger.i("Game was not running. Starting new game -> Switching screen");

      // switch to opponent selection screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OpponentSelectionScreen(
            setId: setId,
          ),
        ),
      );
    } else {
      logger.i("Previous game hasn't finished. Loading");
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Previous game has not finished"),
              content: Text("Do you want to reload your old game?"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Yes"),
                  onPressed: () async {
                    logger.i("User wants to load old game. Loading.");

                    var gameData = await FileUtils().readGameDataFromDisk();
                    NoGlobalVariablesHere().gameData = gameData;

                    logger.i("Old game state loaded. Switching screen");
                    if (gameData.playerTurn) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return PreBattleUserScreen(
                            pathToCardBack: pathToCardBack,
                          );
                        }),
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return PreBattleOpponentScreen(
                            pathToCardBack: pathToCardBack,
                          );
                        }),
                      );
                    }
                  },
                ),
                FlatButton(
                  child: Text("No"),
                  onPressed: () {
                    logger
                        .i("User wants to start new game -> Switching screen");

                    // switch to opponent selection screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OpponentSelectionScreen(
                          setId: setId,
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          });
    }

    var cardsetlist = NoGlobalVariablesHere().cardSetList;
    for (int i = 0; i < cardsetlist.length; i++) {
      logger.i(
          "Oi: Card Set $i -> [${cardsetlist[i].id}] ${cardsetlist[i].name}");
    }
  }

  /// Functionality of the pokedex button.
  ///
  /// [context] is required to change the active
  /// screen via [Navigator.push].
  _pokedexButtonFunction(BuildContext context) {
    logger.i("Pokédex Button tapped -> Switching screen");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PokedexScreen()));
  }

  /// Functionality of the opponents button.
  ///
  /// [context] is required to change the active
  /// screen via [Navigator.push].
  _opponentsButtonFunction(BuildContext context) {
    logger.i("Opponent Button tapper -> Switching screen");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => OpponentScreen()));
  }

  /// Functionality of the settings button.
  ///
  /// [context] is required to change the active
  /// screen via [Navigator.push].
  _settingsButtonFunction(BuildContext context) async {
    logger.i("Settings Button tapped -> Loading User Defaults");

    var prefs = await SharedPreferences.getInstance();
    var sleevePath = prefs.getString(PrefsConstants.cardSleevePrefsKey) ??
        "assets/img/sleeve/card_sleeve_basic.png";
    var setId = prefs.getInt(PrefsConstants.cardSetPrefsKey) ?? 0;

    logger.i(
        "Loaded sleeve path and set id from User Defaults -> Switching screen");

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SettingsScreen(
                  initialSleevePath: sleevePath,
                  initialSetId: setId,
                )));
  }

  _showMatchHistory(BuildContext context) async {
    logger.i("Fetching data from database.");
    var databaseManager = GameHistoryDataBase();
    var gamesList = await databaseManager.fetchGamesFromDB();
    logger.e("Data collected. Switching screen");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameHistoryScreen(
          entries: gamesList,
        ),
      ),
    );
  }
}
