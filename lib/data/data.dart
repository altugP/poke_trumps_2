import 'package:poke_trumps/data/game_data.dart';
import 'package:poke_trumps/data/opponent.dart';
import 'package:poke_trumps/data/set_podo.dart';

/// A singleton class that definitaly could not
/// be refractored to be a file that contains
/// global variables; or an object that gets passed
/// around like my girlfirend.
class NoGlobalVariablesHere {
  // ! Singleton stuff
  static final NoGlobalVariablesHere _instance =
      NoGlobalVariablesHere._internal();
  factory NoGlobalVariablesHere() => _instance;

  // ! actual variables/fields
  List<CardSet> cardSetList; // list of all card sets
  List<Opponent> opponentList; // list of all opponents
  GameData gameData;

  NoGlobalVariablesHere._internal() {
    cardSetList = [];
    _initOpponents();
  }

  /// Creates the four basic opponents as [Opponent]
  /// data objects and adds them to [opponentList].
  void _initOpponents() {
    opponentList = [];
    opponentList.add(
      Opponent(
        id: 0,
        name: "Brock Obama",
        difficulty: Difficulty.EASY,
        backStory:
            "Having spent all his youth in Kenya Brock swore to himself to one day travel to America and make a living there. This has led to him becoming twisted and unpredictable in his actions.",
        pathToMainImage: "assets/img/gym/brock_obama.png",
        pathToChibiImage: "assets/img/gym/brock_chibi.png",
      ),
    );
    opponentList.add(
      Opponent(
        id: 1,
        name: "Altisty",
        difficulty: Difficulty.MEDIUM,
        backStory:
            "Strong. Hot. Biggest brain in EU - West. Altisty has it all. The only thing missing is a consistent win rate in her matches. FeelsBadMan.",
        pathToMainImage: "assets/img/gym/misty_altug.png",
        pathToChibiImage: "assets/img/gym/misty_chibi.png",
      ),
    );
    opponentList.add(
      Opponent(
        id: 2,
        name: "Lt. Halil",
        difficulty: Difficulty.MEDIUM,
        backStory:
            "\"First I hit the gym, then I hit my wife.\" - Lt. Halil on how he spends his mornings.",
        pathToMainImage: "assets/img/gym/lt_surge_halil.png",
        pathToChibiImage: "assets/img/gym/lt_surge_chibi.png",
      ),
    );
    opponentList.add(
      Opponent(
        id: 3,
        name: "Erikenes",
        difficulty: Difficulty.HARD,
        backStory:
            "Eventhough she appears high, she has never even touched weed in her life. Which is odd for a grass type gym leader...",
        pathToMainImage: "assets/img/gym/erika_enes.png",
        pathToChibiImage: "assets/img/gym/erika_chibi.png",
      ),
    );
  }

  @override
  String toString() {
    return "CardSetList from Singleton: " +
        cardSetList[0].toString() +
        " | " +
        cardSetList[1].toString();
  }
}
