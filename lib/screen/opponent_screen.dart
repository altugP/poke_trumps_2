import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:poke_trumps/config/app_colors.dart';
import 'package:poke_trumps/config/neumorph.dart';
import 'package:poke_trumps/data/data.dart';
import 'package:poke_trumps/data/opponent.dart';
import 'package:poke_trumps/widget/transparent_app_bar.dart';

/// A screen that showcases information about all possible
/// opponents the player can face.
///
/// This automatically updates every time opponents change
/// in [NoGlobalVariablesHere].
class OpponentScreen extends StatelessWidget {
  final AppColors appColors = AppColors();
  final NeumorphConstants neumorph = NeumorphConstants();

  @override
  Widget build(BuildContext context) {
    // these have to be here without an await, trust me on this one
    precacheImage(AssetImage("assets/img/gym/brock_obama.png"), context);
    precacheImage(AssetImage("assets/img/gym/misty_altug.png"), context);
    precacheImage(AssetImage("assets/img/gym/lt_surge_halil.png"), context);
    precacheImage(AssetImage("assets/img/gym/erika_enes.png"), context);

    var content = DefaultTabController(
      length: NoGlobalVariablesHere().opponentList.length,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: TransparentAppBar().create(
          Text(
            "Opponents",
            style: TextStyle(
              color: appColors.standardTextColor,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          tabBar: TabBar(
            indicatorColor: Colors.red,
            tabs: <Widget>[
              ...NoGlobalVariablesHere().opponentList.map(
                    (opponent) => Tab(
                      icon: Image.asset(
                        opponent.pathToChibiImage,
                      ),
                    ),
                  ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ...NoGlobalVariablesHere()
                .opponentList
                .map((opponent) => _buildOpponentShowCase(opponent)),
          ],
        ),
      ),
    );

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: neumorph.neumorphColorBackground,
      child: content,
    );
  }

  /// Returns a [Widget] showing [opponent]'s main image
  /// next to some text in neumorphic [Container]s.
  Widget _buildOpponentShowCase(Opponent opponent) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Image.asset(opponent.pathToMainImage),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    width: double.infinity,
                    height: 50,
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
                    child: Center(
                      child: Text(
                        opponent.name,
                        style: TextStyle(
                            color: appColors.standardTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    width: double.infinity,
                    height: 200,
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
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: AutoSizeText(
                          opponent.backStory,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    width: double.infinity,
                    height: 150,
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
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Center(
                        child: AutoSizeText(
                          _getDifficultyString(opponent.difficulty),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Returns a cringy [String] about the opponents [difficulty]
  /// level.
  String _getDifficultyString(Difficulty difficulty) {
    return (difficulty == Difficulty.EASY)
        ? "This character is the worst opponent in the game. All actions are completely random."
        : (difficulty == Difficulty.MEDIUM)
            ? "This enemy requires a bit of a brain to consistently beat. Selecting only the best value on their card makes for a tough opponent. Who would have thought?"
            : (difficulty == Difficulty.HARD)
                ? "This cruel character is certainly hard to beat, but it is not impossible to do so. Sure, counting all cards and making a statistical analysis on the game state sounds strong but the opponent does not have psychic powers, right?"
                : "Someone messed up. Blame Team Kappe!";
  }
}
