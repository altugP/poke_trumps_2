import 'package:flutter/material.dart';
import 'package:poke_trumps/config/app_colors.dart';
import 'package:poke_trumps/config/neumorph.dart';
import 'package:poke_trumps/data/data.dart';
import 'package:poke_trumps/data/preferences_constants.dart';
import 'package:poke_trumps/screen/pre_battle_player_screen.dart';
import 'package:poke_trumps/widget/transparent_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A Widget that's to be shown to the user if a new game starts.
class VsScreen extends StatefulWidget {
  VsScreen();

  @override
  _VsScreenState createState() => _VsScreenState();
}

class _VsScreenState extends State<VsScreen> {
  final AppColors appColors = AppColors();
  final NeumorphConstants neumorph = NeumorphConstants();

  double _playerWidth = 64;
  double _playerOpacity = 0.0;
  var _playerAlignment = Alignment.topLeft;

  double _vsTextSize = 30;
  double _vsOpacity = 0.0;
  var _vsAlignment = Alignment.topCenter;

  double _opponentWidth = 64;
  double _opponentOpacity = 0.0;
  var _opponentAlignment = Alignment.topRight;

  double _beginTextSize = 50;
  double _beginTextOpacity = 0.0;
  var _beginTextAlignment = Alignment.topCenter;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(milliseconds: 500),
      () => setState(() {
        _playerAlignment = Alignment.centerLeft;
        _playerOpacity = 1.0;
      }),
    )
        .then(
          (_) => Future.delayed(
            Duration(seconds: 1),
            () => setState(() {
              _vsAlignment = Alignment.center;
              _vsOpacity = 1.0;
            }),
          ),
        )
        .then(
          (_) => Future.delayed(
            Duration(seconds: 1),
            () => setState(() {
              _opponentAlignment = Alignment.centerRight;
              _opponentOpacity = 1.0;
            }),
          ),
        )
        .then(
          (_) => Future.delayed(
            Duration(seconds: 2),
            () => setState(() {
              _beginTextAlignment = Alignment.bottomCenter;
              _beginTextOpacity = 1.0;
            }),
          ),
        )
        .then((_) => Future.delayed(
            Duration(seconds: 1), () => _preparePreBattleScreen()));
  }

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
            "Game Start",
            style: TextStyle(
              color: appColors.standardTextColor,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: false,
        ),
        body: Stack(
          children: <Widget>[
            // player
            Padding(
              padding: const EdgeInsets.all(24),
              child: AnimatedContainer(
                alignment: _playerAlignment,
                child: Opacity(
                  opacity: _playerOpacity,
                  child: Hero(
                    tag: "player",
                    child: Image.asset(
                      "assets/img/gym/male_chibi.png",
                      fit: BoxFit.fill,
                      width:
                          _playerWidth, // no need for height since fit = fill
                    ),
                  ),
                ),
                duration: Duration(seconds: 1),
                curve: Curves
                    .fastLinearToSlowEaseIn, // ease, fastLinearToSlowEaseIn
              ),
            ),
            // vs
            Padding(
              padding: const EdgeInsets.all(24),
              child: AnimatedContainer(
                alignment: _vsAlignment,
                child: Opacity(
                  opacity: _vsOpacity,
                  child: Text(
                    "🆚",
                    style: TextStyle(fontSize: _vsTextSize),
                  ),
                ),
                duration: Duration(seconds: 1),
                curve: Curves
                    .fastLinearToSlowEaseIn, // ease, fastLinearToSlowEaseIn
              ),
            ),
            // opponent
            Padding(
              padding: const EdgeInsets.all(24),
              child: AnimatedContainer(
                alignment: _opponentAlignment,
                child: Opacity(
                  opacity: _opponentOpacity,
                  child: Hero(
                    tag:
                        "opponent${NoGlobalVariablesHere().gameData.opponent.id}",
                    child: Image.asset(
                      NoGlobalVariablesHere()
                          .gameData
                          .opponent
                          .pathToChibiImage,
                      fit: BoxFit.fill,
                      width: _opponentWidth,
                    ),
                  ),
                ),
                duration: Duration(seconds: 1),
                curve: Curves
                    .fastLinearToSlowEaseIn, // ease, fastLinearToSlowEaseIn
              ),
            ),
            Padding(
              padding: EdgeInsets.all(50),
              child: AnimatedContainer(
                alignment: _beginTextAlignment,
                child: Opacity(
                  opacity: _beginTextOpacity,
                  child: Text(
                    "BEGIN",
                    style: TextStyle(
                      fontSize: _beginTextSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                duration: Duration(seconds: 2),
                curve: Curves.fastLinearToSlowEaseIn,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Prepares to and actually does load next screen onto
  /// Navigator.
  ///
  /// Calls [SharedPreferences] to get the user's preferred
  /// card sleeve and loads that string into [PreBattleUserScreen].
  _preparePreBattleScreen() async {
    var pathToCardBack = "assets/img/sleeve/card_sleeve_basic.png"; // fallback
    var prefs = await SharedPreferences.getInstance();
    pathToCardBack =
        prefs.getString(PrefsConstants.cardSleevePrefsKey) ?? pathToCardBack;

    // set in shared prefs that a game is currently running
    prefs.setBool(PrefsConstants.gameRunningPrefsKey, true);

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
