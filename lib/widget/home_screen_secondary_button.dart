import 'package:flutter/material.dart';
import 'package:poke_trumps/config/app_colors.dart';
import 'package:poke_trumps/config/neumorph.dart';

/// Neumorphic Button containing an image and a
/// subtext underneath it.
class SecondaryButton extends StatelessWidget {
  final NeumorphConstants neumorph = NeumorphConstants();
  final AppColors appColors = AppColors();

  final double size = 100;
  final double imageSize = 80;

  final Function onTap;
  final String pathToImage;
  final String text;

  SecondaryButton({
    @required this.onTap,
    @required this.pathToImage,
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    var imageContainer = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: neumorph.neumorphColorBackground,
        borderRadius: BorderRadius.circular(25),
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
            pathToImage,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );

    var text = Text(
      this.text,
      style: TextStyle(
        color: appColors.standardTextColor,
        fontSize: 20,
      ),
    );

    return GestureDetector(
      onTap: onTap ?? null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          imageContainer,
          SizedBox(
            height: 10,
          ),
          text,
        ],
      ),
    );
  }
}
