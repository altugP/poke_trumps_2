import 'package:flutter/material.dart';
import 'package:poke_trumps/config/app_colors.dart';
import 'package:poke_trumps/config/neumorph.dart';
import 'package:poke_trumps/data/data.dart';
import 'package:poke_trumps/data/pokemon_podo.dart';
import 'package:poke_trumps/engine/stat_evaluator.dart';
import 'package:poke_trumps/screen/pokemon_info_screen.dart';
import 'package:poke_trumps/widget/transparent_app_bar.dart';

/// Screen that displays all cards in every set
/// in a [GridView].
class PokedexScreen extends StatelessWidget {
  final NeumorphConstants neumorph = NeumorphConstants();
  final AppColors appColors = AppColors();

  @override
  Widget build(BuildContext context) {
    var content = DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: TransparentAppBar().create(
          Text(
            "Pokédex",
            style: TextStyle(
              color: appColors.standardTextColor,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          tabBar: TabBar(
            indicatorColor: Colors.red,
            tabs: <Widget>[
              Tab(
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Set",
                      style: TextStyle(color: appColors.standardTextColor),
                    ),
                    Icon(
                      Icons.looks_one,
                      color: appColors.standardTextColor,
                    ),
                  ],
                ),
              ),
              Tab(
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Set",
                      style: TextStyle(color: appColors.standardTextColor),
                    ),
                    Icon(
                      Icons.looks_two,
                      color: appColors.standardTextColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _setRepresentation(context, 0),
            _setRepresentation(context, 1),
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

  /// Returns a [GridView] displaying all cards of set with
  /// id = [index].
  ///
  /// Takes the set from [NoGlobalVariablesHere].
  Widget _setRepresentation(BuildContext context, int index) {
    return HelperGridView(
      context: context,
      neumorph: neumorph,
      setIndex: index,
    ).build();
  }
}

/// A helper class that provides methods to represent a
/// [PokemonCardData] on screen as well as a method to
/// order them in a two column grid.
class HelperGridView {
  final BuildContext context;
  final NeumorphConstants neumorph;
  final int setIndex;

  HelperGridView({this.context, this.neumorph, this.setIndex});

  /// Creates a similar button to [HomeScreen]'s buttons.
  ///
  /// Card name and type are displayed in a row above the
  /// button. [cardData]'s animation (if not a pokeball) is
  /// displayed underneath that in an isolated container complex.
  Widget _pokemonCardRepresentation(PokemonCardData cardData) {
    double outerSize = 120;
    double innerSize = 100;

    var animatedCard = Container(
      width: outerSize,
      height: outerSize,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: neumorph.neumorphColorDarkShadow, // darker shadow
            blurRadius:
                neumorph.neumorphNumberBlurRadius, // softening of shadow
            offset: Offset(neumorph.neumorphNumberUniversalOffset,
                neumorph.neumorphNumberUniversalOffset),
          ),
          BoxShadow(
            color: neumorph.neumorphColorLightShadow, // white shadow
            blurRadius:
                neumorph.neumorphNumberBlurRadius, // softening of shadow
            offset: Offset(-neumorph.neumorphNumberUniversalOffset,
                -neumorph.neumorphNumberUniversalOffset),
          ),
        ],
      ),
      child: Container(
        width: outerSize,
        height: outerSize,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: neumorph.neumorphColorBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Hero(
          tag: cardData.name,
          child: Image.asset(
            cardData.pathToAnimation,
            width: innerSize,
            height: innerSize,
          ),
        ),
      ),
    );

    var decoratedName = Container(
      width: outerSize,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: neumorph.neumorphColorDarkShadow, // darker shadow
            blurRadius:
                neumorph.neumorphNumberBlurRadius, // softening of shadow
            offset: Offset(
              neumorph.neumorphNumberUniversalOffset,
              neumorph.neumorphNumberUniversalOffset,
            ),
          ),
          BoxShadow(
            color: neumorph.neumorphColorLightShadow, // light shadow
            blurRadius:
                neumorph.neumorphNumberBlurRadius, // softening of shadow
            offset: Offset(
              -neumorph.neumorphNumberUniversalOffset,
              -neumorph.neumorphNumberUniversalOffset,
            ),
          ),
        ],
      ),
      child: Container(
        width: outerSize,
        decoration: BoxDecoration(
          color: neumorph.neumorphColorBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text("${cardData.name}"),
            Image.asset(
              "assets/icon/type/${cardData.pokemonType.toString().split(".")[1].toLowerCase()}.png",
              width: 30,
              height: 30,
            )
          ],
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        decoratedName,
        Padding(
          padding: EdgeInsets.only(bottom: 10),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PokemonInfoScreen(
                cardData: cardData,
                statEvaluator: StatEvaluator(
                  cardSet:
                      NoGlobalVariablesHere().cardSetList[cardData.setID].cards,
                ),
              ),
            ),
          ),
          child: animatedCard,
        ),
      ],
    );
  }

  /// Creates a 2D array of widgets and displays them in
  /// a scrollable environment.
  ///
  /// Internally maps selected deck with [_pokemonCardRepresentation()]
  /// and deconstructs that array to add them separately and in order into
  /// a [GridView].
  ///
  /// Uses lots of tested Magic Numbers.
  Widget build() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: neumorph.neumorphColorBackground,
      child: GridView.count(
        primary: true, // use primary color to paint
        padding: EdgeInsets.all(30),
        crossAxisCount: 2, // 2 elements per row
        childAspectRatio: 1.0,
        mainAxisSpacing: 30,
        crossAxisSpacing: 30,
        children: <Widget>[
          ...NoGlobalVariablesHere()
              .cardSetList[setIndex]
              .cards
              .map((cardData) => _pokemonCardRepresentation(cardData)),
        ],
      ),
    );
  }
}
