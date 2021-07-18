import 'dart:math' as math;

import 'package:poke_trumps/data/data.dart';
import 'package:poke_trumps/data/pokemon_podo.dart';
import 'package:poke_trumps/engine/deck_utils.dart';
import 'package:poke_trumps/engine/stat_evaluator.dart';
import 'package:poke_trumps/screen/battle_screen.dart';

abstract class Brain {
  int makeMove(PokemonCardData cardData) {
    return 0;
  }
}

/// Class that implements [Brain].
///
/// Use this in [Difficulty.EASY] opponents.
/// Takesa random value of the given card
/// and returns that value's value in [BattleScreen]'s
/// convention.
class SmallBrain implements Brain {
  final math.Random random = math.Random();

  @override
  int makeMove(PokemonCardData cardData) {
    var result = random.nextInt(3); // random number e [0, 3)
    return result;
  }
}

/// Class that implements [Brain].
///
/// Use this in [Difficulty.MEDIUM] opponents.
/// Takes the best single value of the given card
/// and returns that value's value in [BattleScreen]'s
/// convention.
class MediumBrain implements Brain {
  @override
  int makeMove(PokemonCardData card) {
    var bestStat = card.bestStat;
    if (bestStat == card.attackValue) return BattleScreen.attackValue;
    if (bestStat == card.defenseValue) return BattleScreen.defenseValue;
    if (bestStat == card.speedValue) return BattleScreen.speedValue;
    return BattleScreen.attackValue; // not needed but I felt like I had to
  }
}

/// Class that implements [Brain].
///
/// Use this in [Difficulty.HARD] opponents.
/// Looks up the win percentages of each stat on its card
/// in comparisson to the entire set - used cards.
/// Then takes the highest value of those three.
///
/// Uses [StatEvaluator] to do the calculations.
/// ? Consider looking up all percentages with appliance
/// ? of type advantages
class BigBrain implements Brain {
  @override
  int makeMove(PokemonCardData cardData) {
    // init values with 0 just because
    double attackPercentage = 0.0;
    double defensePercentage = 0.0;
    double speedPercentage = 0.0;

    // prepare deck: only cards that are in the set and havn't been played yet should be considered
    var fullDeckList = NoGlobalVariablesHere().gameData.cardSet.cards;
    // wen have to do this to not delete cards from the actual deck
    var tmpList = shuffle(fullDeckList);
    List<PokemonCardData> cardsToConsider = [];
    for (int i = 0; i < tmpList.length; i++) {
      cardsToConsider.add(tmpList[i]);
    }
    var usedCardsList = NoGlobalVariablesHere().gameData.usedCards;
    // after this [fullDeckList] should contain all relevant cards
    usedCardsList.forEach(
      (usedCard) =>
          cardsToConsider.removeWhere((card) => card.id == usedCard.id),
    );
    // init statEvaluator with those cards
    var statEvaluator = StatEvaluator(cardSet: fullDeckList);

    // re evaluate old values
    attackPercentage = statEvaluator.getWinPercentageInAttack(cardData.id);
    defensePercentage = statEvaluator.getWinPercentageInDefense(cardData.id);
    speedPercentage = statEvaluator.getWinPercentageInSpeed(cardData.id);

    // statistical analysis: highest value = most likely to win
    var max = [
      attackPercentage,
      defensePercentage,
      speedPercentage,
    ].reduce(math.max);

    return (max == attackPercentage)
        ? BattleScreen.attackValue
        : (max == defensePercentage)
            ? BattleScreen.defenseValue
            : (max == speedPercentage)
                ? BattleScreen.speedValue
                : BattleScreen.attackValue;
  }
}

/// Just because we could do it here.
extension ComUtilities on PokemonCardData {
  int get bestStat =>
      [this.attackValue, this.defenseValue, this.speedValue].reduce(math.max);
}
