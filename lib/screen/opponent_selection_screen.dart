import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:poke_trumps/config/app_colors.dart';
import 'package:poke_trumps/config/neumorph.dart';
import 'package:poke_trumps/data/data.dart';
import 'package:poke_trumps/data/game_data.dart';
import 'package:poke_trumps/data/opponent.dart';
import 'package:poke_trumps/engine/file_utils.dart';
import 'package:poke_trumps/screen/vs_screen.dart';
import 'package:poke_trumps/widget/transparent_app_bar.dart';

/// Screen that displays all opponents and lets user
/// choose between them.
class OpponentSelectionScreen extends StatelessWidget {
  final int setId;

  OpponentSelectionScreen({this.setId});

  final NeumorphConstants neumorph = NeumorphConstants();
  final AppColors appColors = AppColors();
  final FileUtils fileUtils = FileUtils();
  final Logger logger = Logger(printer: PrettyPrinter());

  @override
  Widget build(BuildContext context) {
    var appBar = TransparentAppBar().create(
      Text(
        "Choose your Opponent",
        style: TextStyle(
          color: appColors.standardTextColor,
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
      ),
    );

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: neumorph.neumorphColorBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBar,
        body: Builder(
          builder: (context) => Column(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Center(child: _buildOpponentTile(0, context))),
                    Expanded(
                        child: Center(child: _buildOpponentTile(1, context))),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Center(child: _buildOpponentTile(2, context))),
                    Expanded(
                        child: Center(child: _buildOpponentTile(3, context))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// UI representation of an [Opponent] with id = [opponentId].
  Widget _buildOpponentTile(int opponentId, BuildContext context) {
    final double appBarHeight = Scaffold.of(context).appBarMaxHeight;
    final double borderRadius = 25;
    final int tilesPerRow = 2;
    final double padding = 20;
    final double contentPadding = 10;
    final double tileWidth =
        MediaQuery.of(context).size.width / tilesPerRow - tilesPerRow * padding;
    final double tileHeight =
        (MediaQuery.of(context).size.height - appBarHeight) / tilesPerRow -
            tilesPerRow * padding;

    var opponent = NoGlobalVariablesHere().opponentList[opponentId];
    final difficultyStar = "⭐"; // emojis ftw
    var difficultyString = "";

    // I'm so sorry for this but it looked so spicy
    for (var i = 0;
        i <
            ((opponent.difficulty == Difficulty.EASY)
                ? 1
                : (opponent.difficulty == Difficulty.MEDIUM)
                    ? 2
                    : (opponent.difficulty == Difficulty.HARD) ? 3 : 0);
        i++) {
      difficultyString += "\n$difficultyStar";
    }

    Widget content = Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.all(contentPadding),
            child: Text(
              opponent.name,
              style: TextStyle(
                color: appColors.standardTextColor,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: contentPadding * tilesPerRow,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(contentPadding),
                child: Image.asset(
                  opponent.pathToMainImage,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.all(contentPadding),
            child: Text(
              difficultyString,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ],
    );

    return Container(
      width: tileWidth,
      height: tileHeight,
      decoration: BoxDecoration(
        color: neumorph.neumorphColorBackground,
        borderRadius: BorderRadius.circular(borderRadius),
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
      child: GestureDetector(
        onTap: () => _selectOpponent(opponentId, context),
        onLongPress: () => _opponentInfoRequested(opponent, context),
        child: content,
      ),
    );
  }

  /// Called when an opponent has been selected.
  ///
  /// Creates a GameData object and writes that blank
  /// object to the disk.
  void _selectOpponent(int opponentId, BuildContext context) {
    var gameData = GameData.createInitial(
        playerTurn: true, opponentId: opponentId, setId: setId);
    logger.i("Deleted old gameData and created new one. Switching Screen");
    NoGlobalVariablesHere().gameData = gameData; // override old gameData
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => VsScreen(),
      ),
    );
  }

  /// Shows a material pop up in the form of an [AlertDialog].
  ///
  /// Shows [opponent]'s backstory and difficulty.
  void _opponentInfoRequested(Opponent opponent, BuildContext context) {
    var dialog = AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Information on ",
            style: TextStyle(color: appColors.standardTextColor),
          ),
          Image.asset(opponent.pathToChibiImage),
        ],
      ),
      content: Text(
        "${opponent.backStory}.\n\n\nDifficulty: ${opponent.difficulty.toString().split(".")[1]}",
        textAlign: TextAlign.justify,
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("OK"),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
      elevation: 24.0,
      backgroundColor: neumorph.neumorphColorBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    );
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return dialog;
      },
    );
  }
}
