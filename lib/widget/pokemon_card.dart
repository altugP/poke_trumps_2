import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:poke_trumps/config/app_colors.dart';
import 'dart:math' as math;

import 'package:poke_trumps/data/pokemon_podo.dart';
import 'package:vector_math/vector_math.dart' as v;

/// A Flip Card widget that displays a [PokemonCardData]
/// in all active play screens.
///
/// This is hopefully responsive in terms of widget size.
class PokemonCardWidget extends StatelessWidget {
  // attributes
  final PokemonCardData card;
  final String pathToCardBack;
  // used to make card flip only once
  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  final AppColors appColors = AppColors();

  /// Basic flexible constructor
  ///
  /// These shouldn't be [@required] since we need an
  /// empty object to call [buildBackgroundCard(cardSleevePath)]
  /// because that method cannot be static.
  PokemonCardWidget({this.card, this.pathToCardBack});

  @override
  Widget build(BuildContext context) {
    // target aspect ratio of a MTG card => 63:88 (W:H)
    final v.Vector2 aspectRatio = v.Vector2(63, 88);
    final double screenWidth = MediaQuery.of(context).size.width;
    // final double screenHeight = MediaQuery.of(context).size.height;

    // Settings
    final double blackBorderWidth = 25;
    final double coloredBorderWidth = 15;
    final double nameColoredBorderWidth = 10;
    // actual card size
    final double cardBorderWidth = screenWidth * 0.875; // old: 315
    final double cardBorderHeight =
        (cardBorderWidth / aspectRatio.x) * aspectRatio.y; // old: 440
    final double cardBorderBorderRadius = 35;
    // size of colored border layer
    final double typeBorderWidth =
        cardBorderWidth - blackBorderWidth; // old: 295
    final double typeBorderHeight =
        cardBorderHeight - blackBorderWidth; // old: 420
    final double typeBorderBorderRadius = 35;
    // size of full image card art
    final double pokemonImageWidth =
        typeBorderWidth - coloredBorderWidth; // old: 285
    final double pokemonImageHeight =
        typeBorderHeight - coloredBorderWidth; // old: 410
    final double pokemonImageBorderRadius = 35;
    // size of colored border around white name container
    final double nameTypeBorderWidth = pokemonImageWidth; // old 285
    final double nameTypeBorderHeight = pokemonImageHeight / 10.0;
    final double nameTypeBorderBorderRadius = 35;
    // size of white container containing name of card
    final double innerNameTextWidth =
        nameTypeBorderWidth - nameColoredBorderWidth; // old 275
    final double innerNameTextHeight =
        nameTypeBorderHeight - nameColoredBorderWidth; // old 30
    final double innerNameBorderRadius = 20;
    // size of stat showing rectangles
    final double valueIndicatorWidth = 45;
    final double valueIndicatorHeight = 45;
    // size of circular container containing animation of the pokemon
    final double heroAnimationWidth = 60;
    final double heroAnimationHeight = 60;
    final double heroAnimationBorderRadius = 1000; // should be circular

    /// Widget decorating the image of [card]
    var pokemonImage = Container(
      width: pokemonImageWidth,
      height: pokemonImageHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(pokemonImageBorderRadius),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(pokemonImageBorderRadius),
        child: Image.asset(card.pathToImage, fit: BoxFit.fill),
      ),
    );

    /// Widget creating the surroundings of [pokemonImage].
    ///
    /// Contains the actiual [pokemonImage]
    var typeBorder = Container(
      width: typeBorderWidth,
      height: typeBorderHeight,
      decoration: BoxDecoration(
        color: appColors.getTypeAppBarColor(card.pokemonType),
        borderRadius: BorderRadius.circular(typeBorderBorderRadius),
      ),
      child: Center(
        child: pokemonImage,
      ),
    );

    /// Widget creating the black MTG-esque outer border.
    ///
    /// Contains [typeBorder]
    var cardBorder = Container(
      width: cardBorderWidth,
      height: cardBorderHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cardBorderBorderRadius),
        color: Colors.black,
      ),
      child: Center(
        child: typeBorder,
      ),
    );

    /// Widget that decorates [card]'s name and type.
    var innerNameText = Container(
      width: innerNameTextWidth,
      height: innerNameTextHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(innerNameBorderRadius),
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                SizedBox(width: 10),
                Text(
                  card.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Image.asset(
                    "assets/icon/type/${card.typeString.toLowerCase()}.png"),
                SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
    );

    /// Creates border around [innerNameText].
    ///
    /// Contains [innerNameText]
    var nameTypeBorder = Container(
      width: nameTypeBorderWidth,
      height: nameTypeBorderHeight,
      decoration: BoxDecoration(
        color: appColors.getTypeAppBarColor(card.pokemonType),
        borderRadius: BorderRadius.circular(nameTypeBorderBorderRadius),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Center(
        child: innerNameText,
      ),
    );

    /// Displays [card]'s animation as a hero image
    /// in a circular border
    var heroAnimation = Container(
      width: heroAnimationWidth,
      height: heroAnimationHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(heroAnimationBorderRadius),
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Hero(
        tag: "${card.id}:${card.name}-battle",
        child: ClipRRect(
          borderRadius: BorderRadius.circular(heroAnimationBorderRadius),
          child: Image.asset(card.pathToAnimation),
        ),
      ),
    );

    var attackIndicator = _buildAttackIndicator(card.attackValue, math.pi / 4,
        valueIndicatorWidth, valueIndicatorHeight);
    var defenseIndicator = _buildDefenseIndicator(card.defenseValue,
        math.pi / 4, valueIndicatorWidth, valueIndicatorHeight);
    var speedIndicator = _buildSpeedIndicator(card.speedValue, math.pi / 4,
        valueIndicatorWidth, valueIndicatorHeight);

    /// A list of positioned indicators and [heroAnimation].
    List<Widget> pokemonStatIndicators = [
      // ? Somehow flutter automatically applies math.sqrt2 to the height of a rotated rectangle
      Positioned(
        top: (cardBorderHeight - valueIndicatorHeight) / 2,
        left: valueIndicatorHeight / 4, // vallah kp
        child: attackIndicator,
      ),
      Positioned(
        top: (cardBorderHeight - valueIndicatorHeight) / 2,
        right: valueIndicatorHeight / 4, // vallah kp
        child: defenseIndicator,
      ),
      Positioned(
        top: valueIndicatorHeight / 4, // vallah kp
        left: (cardBorderWidth - valueIndicatorWidth) / 2,
        child: speedIndicator,
      ),
      Positioned(
        top: cardBorderHeight -
            heroAnimationHeight -
            nameTypeBorderHeight +
            5, // slightly (5px) overlap name fields
        left: (cardBorderWidth - heroAnimationWidth) / 2,
        child: heroAnimation,
      ),
    ];

    /// The front side of the card containing all delcared widgets
    ///
    /// ! REMINDER: in a [FlipCard] this is actually the back side
    var frontSideOfCard = Stack(
      children: <Widget>[
        cardBorder,
        Positioned(
          top: cardBorderHeight - nameTypeBorderHeight - 10,
          left: (cardBorderWidth - nameTypeBorderWidth) / 2,
          child: nameTypeBorder,
        ),
        ...pokemonStatIndicators,
      ],
    );

    return FlipCard(
      key: cardKey,
      flipOnTouch: false,
      front: GestureDetector(
        child: Container(
          width: cardBorderWidth,
          height: cardBorderHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(cardBorderBorderRadius),
          ),
          child: Image.asset(
            pathToCardBack ?? "assets/img/sleeve/card_sleeve_basic.png",
            fit: BoxFit.fill,
          ),
        ),
        onTap: () => cardKey.currentState.toggleCard(),
      ),
      back: frontSideOfCard,
    );
  }

  /// Builds and returns a Widget displaying
  /// an attack icon and [value] as text.
  ///
  /// Helper function that calls [_buildStatIndicator("attack", value)].
  Widget _buildAttackIndicator(
      int value, double rotation, double width, double height) {
    return _buildStatIndicator(
        "attack", value.toString(), rotation, width, height);
  }

  /// Builds and returns a Widget displaying
  /// a defense icon and [value] as text.
  ///
  /// Helper function that calls [_buildStatIndicator("defense", value)].
  Widget _buildDefenseIndicator(
      int value, double rotation, double width, double height) {
    return _buildStatIndicator(
        "defense", value.toString(), rotation, width, height);
  }

  /// Builds and returns a Widget displaying
  /// a speed icon and [value] as text.
  ///
  /// Helper function that calls [_buildStatIndicator("speed", value)].
  Widget _buildSpeedIndicator(
      int value, double rotation, double width, double height) {
    return _buildStatIndicator(
        "speed", value.toString(), rotation, width, height);
  }

  // Builds and returns a Widget displaying
  /// an icon according to [type], and [value] as text.
  ///
  /// Uses emojis (OMEGALUL) to display all info inside
  /// a Text Widget, which is wrapped in a decorated
  /// [Container].
  Widget _buildStatIndicator(String statName, String value, double rotation,
      double width, double height) {
    // ? how would you do this in MS Paint?
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Center(
          // turn back so this text stays unrotated
          child: Transform.rotate(
            angle: -rotation,
            child: Text(
              ((statName == "attack")
                      ? "⚔️"
                      : (statName == "defense")
                          ? "🛡️"
                          : (statName == "speed")
                              ? "💨"
                              : "❌") + // shouldn't happen
                  "$value",
              style: TextStyle(
                fontSize:
                    16, // maximum font size to still allow stuff like deoxy's speed
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Returns an [Image] with the chosen card back
  /// and the dimensions of a regular card.
  Widget buildBackgroundCard(String cardSleevePath, BuildContext context) {
    // target aspect ratio of a MTG card => 63:88 (W:H)
    final v.Vector2 aspectRatio = v.Vector2(63, 88);
    final double screenWidth = MediaQuery.of(context).size.width;
    // final double screenHeight = MediaQuery.of(context).size.height;

    // actual card size
    final double cardBorderWidth = screenWidth * 0.875; // old: 315
    final double cardBorderHeight =
        (cardBorderWidth / aspectRatio.x) * aspectRatio.y; // old: 440

    return Image.asset(
      cardSleevePath,
      width: cardBorderWidth,
      height: cardBorderHeight,
      fit: BoxFit.fill,
    );
  }
}
