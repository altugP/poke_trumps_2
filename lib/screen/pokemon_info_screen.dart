import 'package:auto_size_text/auto_size_text.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:poke_trumps/config/app_colors.dart';
import 'package:poke_trumps/config/neumorph.dart';
import 'package:poke_trumps/config/pokemon_type_settings.dart';
import 'package:poke_trumps/data/data.dart';
import 'package:poke_trumps/data/pokemon_podo.dart';
import 'package:poke_trumps/data/set_podo.dart';
import 'package:poke_trumps/engine/stat_evaluator.dart';

/// This screen shows information to the selected
/// [PokemonCardData].
///
/// Gets called in [PokedexScreen].
class PokemonInfoScreen extends StatelessWidget {
  final NeumorphConstants neumorph = NeumorphConstants();
  final AppColors appColors = AppColors();
  final PokemonTypeSettings typeSettings = PokemonTypeSettings();

  final PokemonCardData cardData;
  final StatEvaluator statEvaluator;

  PokemonInfoScreen({@required this.cardData, @required this.statEvaluator});

  @override
  Widget build(BuildContext context) {
    // semi dynamic size settings
    // ! I know AspectRatio is a widget but I didn't want to use an Expanded now
    double outerWidth = MediaQuery.of(context).size.width * 0.8; // old: 300
    double outerHeight = 1.6733 * outerWidth; // old: 502
    double imageContainerWidth =
        MediaQuery.of(context).size.width * 0.5; // old: 180
    double imageContainerHeight = imageContainerWidth;

    var contentCard = Container(
      width: outerWidth,
      height: outerHeight,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black45, // immitate material shadow
            blurRadius: neumorph.neumorphNumberBlurRadius,
            offset: Offset(
              neumorph.neumorphNumberUniversalOffset,
              neumorph.neumorphNumberUniversalOffset,
            ),
          ),
        ],
        color: neumorph.neumorphColorBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center, // center vertically
        children: <Widget>[
          Hero(
            tag: cardData.name,
            child: Container(
              height: imageContainerHeight,
              width: imageContainerWidth,
              decoration: BoxDecoration(
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
              child: Container(
                height: imageContainerHeight,
                width: imageContainerWidth,
                decoration: BoxDecoration(
                  color: neumorph.neumorphColorBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Image.asset(
                      cardData.pathToAnimation,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // card name
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                cardData.name,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Text("Card ${cardData.id + 1} in Set ${cardData.setID + 1}"),
            ],
          ),
          // card type icon and text
          Column(
            children: <Widget>[
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
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
                child: Container(
                  width: 64,
                  height: 64,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: neumorph.neumorphColorBackground,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.asset(
                    "assets/icon/type/${cardData.typeString.toLowerCase()}.png",
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                "${cardData.pokemonType.toString().split(".")[1].substring(0, 1).toUpperCase()}"
                "${cardData.pokemonType.toString().split(".")[1].substring(1).toLowerCase()} "
                "Type Pokemon",
              ),
            ],
          ),
          // stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "ATK: ${cardData.attackValue}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "DEF: ${cardData.defenseValue}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "SPE: ${cardData.speedValue}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );

    var backSideCard = Container(
      width: outerWidth,
      height: outerHeight,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black45, // immitate material shadow
            blurRadius:
                neumorph.neumorphNumberBlurRadius, // softening of shadow
            offset: Offset(
              neumorph.neumorphNumberUniversalOffset,
              neumorph.neumorphNumberUniversalOffset,
            ),
          ),
        ],
        color: neumorph.neumorphColorBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          cardData.pathToImage,
          fit: BoxFit.fill,
        ),
      ),
    );

    return Scaffold(
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: Transform(
                  transform: Matrix4.identity()..setEntry(0, 0, -1), // mirror
                  alignment: FractionalOffset.center,
                  child: Image.asset(cardData.pathToAnimation),
                ),
              ),
              decoration: BoxDecoration(
                gradient: appColors.getTypeGradient(cardData.pokemonType),
              ),
            ),
            Divider(),
            ListTile(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "${cardData.name}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: appColors.standardTextColor,
                    ),
                  ),
                  Text("(s${cardData.setID}:i${cardData.id})"),
                ],
              ),
            ),
            Divider(),
            ListTile(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Strong against (deals more damage to)",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ...typeSettings.typeStrengths[cardData.pokemonType].map(
                        (type) => Image.asset(
                          "assets/icon/type/${type.toString().split(".")[1].toLowerCase()}.png",
                          width: 25,
                          height: 25,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(),
            ListTile(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Weak against (deals less damage to)",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ...typeSettings.typeWeaknesses[cardData.pokemonType].map(
                        (type) => Image.asset(
                          "assets/icon/type/${type.toString().split(".")[1].toLowerCase()}.png",
                          width: 25,
                          height: 25,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(),
            ListTile(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Ineffective against (deals no damage to)",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ...typeSettings
                          .typeIneffectivenesses[cardData.pokemonType]
                          .map(
                        (type) => Image.asset(
                          "assets/icon/type/${type.toString().split(".")[1].toLowerCase()}.png",
                          width: 25,
                          height: 25,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Data regarding Set ${cardData.setID + 1}:"),
                  IconButton(
                    icon: Icon(
                      Icons.info_outline,
                      color: appColors.standardTextColor,
                    ),
                    onPressed: () => _showSetInfoPopUp(context,
                        NoGlobalVariablesHere().cardSetList[cardData.setID]),
                  ),
                ],
              ),
            ),
            Divider(),
            ListTile(
              title: Text(
                "Percentages for Attack",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Win percentage in Attack: "),
                  Text(
                      "${statEvaluator.percentageString(statEvaluator.getWinPercentageInAttack(cardData.id))}"),
                ],
              ),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Draw percentage in Attack: "),
                  Text(
                      "${statEvaluator.percentageString(statEvaluator.getDrawPercentageInAttack(cardData.id))}"),
                ],
              ),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Loss percentage in Attack: "),
                  Text(
                      "${statEvaluator.percentageString(statEvaluator.getLossPercentageInAttack(cardData.id))}"),
                ],
              ),
            ),
            Divider(),
            ListTile(
              title: Text(
                "Percentages for Defense",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Win percentage in Defense: "),
                  Text(
                      "${statEvaluator.percentageString(statEvaluator.getWinPercentageInDefense(cardData.id))}"),
                ],
              ),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Draw percentage in Defense: "),
                  Text(
                      "${statEvaluator.percentageString(statEvaluator.getDrawPercentageInDefense(cardData.id))}"),
                ],
              ),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Loss percentage in Defense: "),
                  Text(
                      "${statEvaluator.percentageString(statEvaluator.getLossPercentageInDefense(cardData.id))}"),
                ],
              ),
            ),
            Divider(),
            ListTile(
              title: Text(
                "Percentages for Speed",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Win percentage in Speed: "),
                  Text(
                      "${statEvaluator.percentageString(statEvaluator.getWinPercentageInSpeed(cardData.id))}"),
                ],
              ),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Draw percentage in Speed: "),
                  Text(
                      "${statEvaluator.percentageString(statEvaluator.getDrawPercentageInSpeed(cardData.id))}"),
                ],
              ),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Loss percentage in Speed: "),
                  Text(
                      "${statEvaluator.percentageString(statEvaluator.getLossPercentageInSpeed(cardData.id))}"),
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appColors.getTypeAppBarColor(cardData.pokemonType),
        title: Text(
          cardData.name,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: appColors.getTypeGradient(cardData.pokemonType),
        ),
        child: Center(
          child: FlipCard(
            direction: FlipDirection.HORIZONTAL,
            front: contentCard,
            back: backSideCard,
          ),
        ),
      ),
    );
  }

  _showSetInfoPopUp(BuildContext context, CardSet cardSet) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Set ${cardSet.id + 1} Information"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  cardSet.pathToImage,
                  width: 80,
                  height: 80,
                ),
                SizedBox(height: 20),
                Container(
                  width: 250,
                  height: 100,
                  child: AutoSizeText(
                    cardSet.description,
                    textAlign: TextAlign.justify,
                    maxFontSize: 20,
                  ),
                ),
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
