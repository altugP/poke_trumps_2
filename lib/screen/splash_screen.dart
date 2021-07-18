import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:poke_trumps/data/data.dart';
import 'package:poke_trumps/data/pokemon_podo.dart';
import 'package:poke_trumps/data/set_podo.dart';
import 'package:poke_trumps/screen/home_screen.dart';

/// A splash screen that is shown to the user
/// while the app loads all deck jsons.
///
/// The duration is always the time the device's
/// cpu takes to load the jsons plus 3 seconds.
/// We wanted everyone to see our splash screen, so we
/// artificially prolongued the duration.
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Logger logger = Logger(printer: PrettyPrinter());

  final Duration delayAfterLoading = Duration(seconds: 3);

  var loadingImage = Image.asset(
    "assets/img/screen/spring_loading.png",
    fit: BoxFit.fill,
  );

  var errorImage = Image.asset(
    "assets/img/screen/missingno_error.png",
    fit: BoxFit.fill,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadAllSetsInOrder(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          logger.i("All sets have been loaded. Starting artificial delay.");
          Future.delayed(delayAfterLoading).then((_) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
            logger.i("Artificial delay is over.");
          });
          return _buildDelayWidget();
        } else if (snapshot.hasError) {
          return _buildErrorWidget();
        } else {
          return _buildLoadingWidget();
        }
      },
    );
  }

  /// This Widget is shown while the [FutureBuilder] actually
  /// waits for all sets to be loaded.
  Widget _buildLoadingWidget() {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: loadingImage,
      ),
    );
  }

  /// This Widget is shown while user has to wait
  /// the artificial waiting period.
  Widget _buildDelayWidget() {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: double.infinity,
          child: loadingImage,
        ),
        Center(
          child: CircularProgressIndicator(),
        ),
      ],
    );
  }

  /// This Widget ist shown when an error occurrs while
  /// loading sets.
  Widget _buildErrorWidget() {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: double.infinity,
          child: errorImage,
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red[800],
                size: 100,
              ),
              Text(
                "An Error occurred while loading :(",
                style: TextStyle(
                    color: Colors.red[800],
                    fontSize: 50,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Helper function that calls [_loadSet()] with
  /// desired settings for loading set0.
  ///
  /// Always returns true.
  Future<bool> _loadSet0() async {
    await _loadSet("assets/set/set0.json");
    logger.i("Added Set0 to Singleton.");
    return true;
  }

  /// Helper function that calls [_loadSet()] with
  /// desired settings for loading set1.
  ///
  /// Always returns true.
  Future<bool> _loadSet1() async {
    await _loadSet("assets/set/set1.json");
    logger.i("Added Set 1 to Singleton.");
    return true;
  }

  /// Asynchronously loads a set json identified by
  /// [internalPathToJson] from the app bundle / apk.
  ///
  /// Directly adds the created [CardSet] object to
  /// [NoGlobalVariablesHere().cardSetList] as it's
  /// last element.
  _loadSet(String internalPathToJson) async {
    var setContentJson = await rootBundle.loadString(internalPathToJson);
    var deck = <PokemonCardData>[];
    var setMap = jsonDecode(setContentJson);

    var setID = setMap["set_id"];
    var setName = setMap["set_name"];
    var setDescription = setMap["set_description"];
    var image = setMap["image"];
    var cards = setMap["cards"];

    for (var i = 0; i < cards.length; i++) {
      var card = PokemonCardData.fromJson(cards[i]);
      deck.add(card);
      logger.v("Added card: ${card.toString()} to the deck.");
    }

    var cardSet = CardSet(
      id: setID,
      name: setName,
      description: setDescription,
      pathToImage: image,
      cards: deck,
    );

    NoGlobalVariablesHere().cardSetList.add(cardSet);
  }

  /// This is the [Future] this [Widget]'s [FutureBuilder]
  /// waits for.
  ///
  /// This could have been replaced by a [Future.wait(...)],
  /// but that won't guarantee processing the sets in correct
  /// order. Hence we await each loading action.
  ///
  /// Always returns true.
  Future<bool> _loadAllSetsInOrder() async {
    await _loadSet0();
    await _loadSet1();
    return true;
  }
}
