import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:poke_trumps/computer/brain.dart';
import 'package:poke_trumps/config/app_colors.dart';
import 'package:poke_trumps/config/neumorph.dart';
import 'package:poke_trumps/data/data.dart';
import 'package:poke_trumps/data/opponent.dart';
import 'package:poke_trumps/data/preferences_constants.dart';
import 'package:poke_trumps/screen/battle_screen.dart';
import 'package:poke_trumps/widget/pokemon_card.dart';
import 'package:poke_trumps/widget/transparent_app_bar.dart';
import 'dart:math' as math;

import 'package:poke_trumps/widget/used_cards_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreBattleOpponentScreen extends StatefulWidget {
  final String pathToCardBack;
  PreBattleOpponentScreen({this.pathToCardBack});
  @override
  _PreBattleOpponentScreenState createState() =>
      _PreBattleOpponentScreenState();
}

class _PreBattleOpponentScreenState extends State<PreBattleOpponentScreen> {
  final AppColors appColors = AppColors();
  final NeumorphConstants neumorph = NeumorphConstants();
  final Logger logger = Logger(printer: PrettyPrinter());

  final String message = "Wait for your Opponent to make a move.";
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
  void initState() {
    super.initState();

    // ai action
    var opponent = NoGlobalVariablesHere().gameData.opponent;
    Brain brain;
    if (opponent.difficulty == Difficulty.EASY)
      brain = SmallBrain();
    else if (opponent.difficulty == Difficulty.MEDIUM)
      brain = MediumBrain();
    else if (opponent.difficulty == Difficulty.HARD)
      brain = BigBrain();
    else
      // shouldn't happen
      brain = MediumBrain();

    Future.delayed(Duration(seconds: 5), () async {
      var valueToCompare = brain.makeMove(
        NoGlobalVariablesHere().gameData.opponentDeck.first,
      );
      logger.i("Ai made up it's mind. Switching screen");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => BattleScreen(
                    valueToCompare: valueToCompare,
                    comingFromPlayer: false,
                    pathToCardBack: widget.pathToCardBack,
                  )));
    });
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
    ///
    /// This should not have a functionality
    var card = PokemonCardWidget(
      card: gameData.playerDeck.first,
      pathToCardBack: widget.pathToCardBack,
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
                      CircularProgressIndicator(
                        backgroundColor: appColors.appBarBottomColor1,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          appColors.appBarBottomColor2,
                        ),
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
}
