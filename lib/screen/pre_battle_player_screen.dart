import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:poke_trumps/config/app_colors.dart';
import 'package:poke_trumps/config/neumorph.dart';
import 'package:poke_trumps/data/data.dart';
import 'package:poke_trumps/data/preferences_constants.dart';
import 'package:poke_trumps/widget/pokemon_card.dart';
import 'package:poke_trumps/widget/transparent_app_bar.dart';
import 'package:poke_trumps/widget/used_cards_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

import 'battle_screen.dart';

class PreBattleUserScreen extends StatefulWidget {
  final String pathToCardBack;
  PreBattleUserScreen({this.pathToCardBack});
  @override
  _PreBattleUserScreenState createState() => _PreBattleUserScreenState();
}

class _PreBattleUserScreenState extends State<PreBattleUserScreen> {
  final AppColors appColors = AppColors();
  final NeumorphConstants neumorph = NeumorphConstants();
  final Logger logger = Logger(printer: PrettyPrinter());

  final String message = "Swipe to play your card.";
  var gameData = NoGlobalVariablesHere().gameData; // too long otherwise

  /// Shows alert pop up if user wants to go back
  /// to previous screen.
  ///
  /// Sets the [PrefsConstants.gameRunningPrefsKey] field in [SharedPreferences]
  /// to false if succesfully popped.
  Future<bool> _onWillPop() async {
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

  @override
  Widget build(BuildContext context) {
    var opponentScoreBar = Row(
      children: <Widget>[
        Hero(
          tag: "opponent${gameData.opponent.id}",
          child: Image.asset(gameData.opponent.pathToChibiImage),
        ),
        Text(
          " Score: ${gameData.opponentScore}",
          style: TextStyle(
            color: appColors.standardTextColor,
            fontSize: 18,
          ),
        ),
      ],
    );

    var playerScoreBar = Row(
      children: <Widget>[
        Hero(
          tag: "player",
          child: Image.asset("assets/img/gym/male_chibi.png"),
        ),
        Text(
          " Score: ${gameData.playerScore}",
          style: TextStyle(
            color: appColors.standardTextColor,
            fontSize: 18,
          ),
        ),
      ],
    );

    var scoreBar = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        playerScoreBar,
        opponentScoreBar,
      ],
    );

    /// actual card widget. To be lying on top of the immitated deck
    var card = GestureDetector(
      child: PokemonCardWidget(
        card: gameData.playerDeck.first,
        pathToCardBack: widget.pathToCardBack,
      ),
      onHorizontalDragEnd: (details) =>
          (details.velocity.pixelsPerSecond.dx > 0)
              ? _rightSwipe()
              : _leftSwipe(),
      onVerticalDragEnd: (details) =>
          (details.velocity.pixelsPerSecond.dy > 0) ? _downSwipe() : _upSwipe(),
    );

    /// Single card back in regular card's dimensions.
    ///
    /// to be added multiple times to immitate a deck
    var backGroundCard =
        PokemonCardWidget().buildBackgroundCard(widget.pathToCardBack, context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: neumorph.neumorphColorBackground,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: TransparentAppBar().create(scoreBar),
          endDrawer: UsedCardsDrawer(),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.info_outline),
                        onPressed: _showInfoAlert,
                      ),
                      SizedBox(width: 20),
                      Text(
                        message,
                        style: TextStyle(
                          color: appColors.standardTextColor,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: <Widget>[
                      Transform.rotate(
                        angle: math.pi / 50,
                        child: Transform.translate(
                          offset: Offset(11.0, 10.0),
                          child: backGroundCard,
                        ),
                      ),
                      Transform.rotate(
                        angle: -math.pi / 50,
                        child: backGroundCard,
                      ),
                      card,
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _rightSwipe() {
    logger.i("Right swipe detected. Switching screen");
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => BattleScreen(
                  valueToCompare: BattleScreen.defenseValue,
                  comingFromPlayer: true,
                  pathToCardBack: widget.pathToCardBack,
                )));
  }

  void _leftSwipe() {
    logger.i("Left swipe detected. Switching screen");
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => BattleScreen(
                  valueToCompare: BattleScreen.attackValue,
                  comingFromPlayer: true,
                  pathToCardBack: widget.pathToCardBack,
                )));
  }

  void _downSwipe() {
    logger.e("Down swipe detected. But no function found :(");
  }

  void _upSwipe() {
    logger.i("Up swipe detected. Switching screen");
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => BattleScreen(
                  valueToCompare: BattleScreen.speedValue,
                  comingFromPlayer: true,
                  pathToCardBack: widget.pathToCardBack,
                )));
  }

  /// Shows an alert dialog explaining where to swipe to select
  /// a specific value to compare in the next fight.
  ///
  /// Sorry for using emojis but I have to use them.
  void _showInfoAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Help"),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Swipe ⬅️ to choose your card's ⚔️Attack⚔️ value.\n"),
                Text("Swipe ➡️ to choose your card's 🛡️Defense🛡️ value.\n"),
                Text("Swipe ⬆️ to choose your card's 💨Speed💨 value."),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        });
  }
}
