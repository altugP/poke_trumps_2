import 'package:flutter/material.dart';
import 'package:poke_trumps/config/app_colors.dart';
import 'package:poke_trumps/config/neumorph.dart';

/// The big pokeball play button
class PlayButton extends StatelessWidget {
  final NeumorphConstants neumorph = NeumorphConstants();
  final AppColors appColors = AppColors();

  final double size = 250;
  final double imageSize = 150;

  final Function onTap;
  PlayButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    var ball = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: neumorph.neumorphColorBackground,
        borderRadius: BorderRadius.circular(10000), // round
        boxShadow: [
          BoxShadow(
            color: neumorph.neumorphColorDarkShadow,
            offset: Offset(
              neumorph.neumorphNumberUniversalOffset,
              neumorph.neumorphNumberUniversalOffset,
            ),
            blurRadius: neumorph.neumorphNumberBlurRadius,
          ),
          BoxShadow(
            color: neumorph.neumorphColorLightShadow,
            offset: Offset(
              -neumorph.neumorphNumberUniversalOffset,
              -neumorph.neumorphNumberUniversalOffset,
            ),
            blurRadius: neumorph.neumorphNumberBlurRadius,
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: imageSize,
          height: imageSize,
          child: Image.asset(
            "assets/icon/pokeball.png",
            fit: BoxFit.fill,
          ),
        ),
      ),
    );

    var text = Text(
      "Play",
      style: TextStyle(
        color: appColors.standardTextColor,
        fontSize: 24,
      ),
    );

    return GestureDetector(
      onTap: onTap ?? null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ball,
          SizedBox(
            height: 10,
          ),
          text,
        ],
      ),
    );
  }
}
