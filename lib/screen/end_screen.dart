import 'package:flutter/material.dart';
import 'package:poke_trumps/screen/home_screen.dart';

/// A simple screen that displays an image congratulating the
/// player on his victory or bullying him because he lost.
class EndScreen extends StatelessWidget {
  final String playerWonImage = "assets/img/screen/win_screen.png";
  final String playerLostImage = "assets/img/screen/lose_screen.png";
  final bool playerWon;

  /// Regular constructor.
  ///
  /// ! IMPORTANT: this has to be pushed via [Navigator.pushReplacement(context, <routeToHere>)]
  /// ! for this to automatically return to [HomeScreen] without giving the user the option
  /// ! to go back via Androids back buttons.
  EndScreen({@required this.playerWon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: GestureDetector(
          child: Image.asset(
            (playerWon) ? playerWonImage : playerLostImage,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
