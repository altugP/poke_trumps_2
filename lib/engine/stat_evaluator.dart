import 'package:flutter/material.dart';
import 'package:poke_trumps/data/pokemon_podo.dart';

/// A utility class that holds methods to compare
/// a [PokemonCardData] to all others in it's set.
class StatEvaluator {
  static int _betterThanThisIndex = 0;
  static int _equalToThisIndex = 1;
  static int _worseThanThisIndex = 2;

  final List<PokemonCardData> cardSet;

  StatEvaluator({@required this.cardSet});

  /// Returns card from [cardSet] with id identical to
  /// given [id].
  ///
  /// Simple for each search.
  PokemonCardData _getCardFromId(int id) {
    var card;
    for (int i = 0; i < cardSet.length; i++) {
      if (cardSet[i].id == id) {
        card = cardSet[i];
        break; // card found
      }
    }
    return card; // shouldn't happen to be null
  }

  /// Returns an array of information about how many other
  /// cards are 1. better than, 2. equal to and 3. worse than
  /// the card with id = [id] regarding their attack values.
  ///
  /// The indexes are displayed as [_betterThanThisIndex],
  /// [_equalToThisIndex] and [_worseThanThisIndex].
  List<int> _getPlaceInAttack(int id) {
    return _getPlaceInStat(id, _Stat.ATTACK);
  }

  /// Returns an array of information about how many other
  /// cards are 1. better than, 2. equal to and 3. worse than
  /// the card with id = [id] regarding their defense values.
  ///
  /// The indexes are displayed as [_betterThanThisIndex],
  /// [_equalToThisIndex] and [_worseThanThisIndex].
  List<int> _getPlaceInDefense(int id) {
    return _getPlaceInStat(id, _Stat.DEFENSE);
  }

  /// Returns an array of information about how many other
  /// cards are 1. better than, 2. equal to and 3. worse than
  /// the card with id = [id] regarding their speed values.
  ///
  /// The indexes are displayed as [_betterThanThisIndex],
  /// [_equalToThisIndex] and [_worseThanThisIndex].
  List<int> _getPlaceInSpeed(int id) {
    return _getPlaceInStat(id, _Stat.SPEED);
  }

  /// Returns an array of information about how many other
  /// cards are 1. better than, 2. equal to and 3. worse than
  /// the card with id = [id] regarding their [stat] values.
  ///
  /// This gets called by the other [_getStatIn_XXX_] methods.
  ///
  /// The indexes are displayed as [_betterThanThisIndex],
  /// [_equalToThisIndex] and [_worseThanThisIndex].
  List<int> _getPlaceInStat(int id, _Stat stat) {
    var card = _getCardFromId(id);

    var amountOfValuesLowerThanThis = 0;
    var amountOfValuesHigherThanThis = 0;
    var amountOfValuesEqualToThis = 0;

    var otherCard;
    for (var i = 0; i < cardSet.length; i++) {
      otherCard = cardSet[i]; // override old card
      if (otherCard.id == card.id) continue; // don't compare to itself

      // only compare relevant stat
      switch (stat) {
        case _Stat.ATTACK:
          if (card.attackValue < otherCard.attackValue) {
            amountOfValuesHigherThanThis++;
          } else if (card.attackValue > otherCard.attackValue) {
            amountOfValuesLowerThanThis++;
          } else {
            amountOfValuesEqualToThis++;
          }
          break;
        case _Stat.DEFENSE:
          if (card.defenseValue < otherCard.defenseValue) {
            amountOfValuesHigherThanThis++;
          } else if (card.defenseValue > otherCard.defenseValue) {
            amountOfValuesLowerThanThis++;
          } else {
            amountOfValuesEqualToThis++;
          }
          break;
        case _Stat.SPEED:
          if (card.speedValue < otherCard.speedValue) {
            amountOfValuesHigherThanThis++;
          } else if (card.speedValue > otherCard.speedValue) {
            amountOfValuesLowerThanThis++;
          } else {
            amountOfValuesEqualToThis++;
          }
          break;
      }
    }

    return [
      amountOfValuesHigherThanThis, // # pokemon better than this
      amountOfValuesEqualToThis, // # pokemon equal to this
      amountOfValuesLowerThanThis // # pokemon worse than this
    ];
  }

  /// Calculates the win percentage of [PokemonCardData] with
  /// id = [id] compared to other cards of [cardSet] under
  /// comparison value of [stat].
  double _getWinPercentageInStat(int id, _Stat stat) {
    var amountOfOtherCards = cardSet.length - 1;
    var amountOfWorseThanThis = (stat == _Stat.ATTACK)
        ? _getPlaceInAttack(id)[_worseThanThisIndex]
        : (stat == _Stat.DEFENSE)
            ? _getPlaceInDefense(id)[_worseThanThisIndex]
            : _getPlaceInSpeed(id)[_worseThanThisIndex];
    return (amountOfWorseThanThis / amountOfOtherCards);
  }

  /// Returns the win percentage of [PokemonCardData] with
  /// id = [id] in his set if the attack value is to be
  /// compared.
  ///
  /// Calls [_getWinPercentageInStat(id, stat)] with
  /// stat = [_Stat.ATTACK].
  double getWinPercentageInAttack(int id) {
    return _getWinPercentageInStat(id, _Stat.ATTACK);
  }

  /// Returns the win percentage of [PokemonCardData] with
  /// id = [id] in his set if the defense value is to be
  /// compared.
  ///
  /// Calls [_getWinPercentageInStat(id, stat)] with
  /// stat = [_Stat.DEFENSE].
  double getWinPercentageInDefense(int id) {
    return _getWinPercentageInStat(id, _Stat.DEFENSE);
  }

  /// Returns the win percentage of [PokemonCardData] with
  /// id = [id] in his set if the speed value is to be
  /// compared.
  ///
  /// Calls [_getWinPercentageInStat(id, stat)] with
  /// stat = [_Stat.SPEED].
  double getWinPercentageInSpeed(int id) {
    return _getWinPercentageInStat(id, _Stat.SPEED);
  }

  /// Calculates the loss percentage of [PokemonCardData] with
  /// id = [id] compared to other cards of [cardSet] under
  /// comparison value of [stat].
  double _getLossPercentageInStat(int id, _Stat stat) {
    var amountOfOtherCards = cardSet.length - 1;
    var amountOfCardsBetterThanThis = (stat == _Stat.ATTACK)
        ? _getPlaceInAttack(id)[_betterThanThisIndex]
        : (stat == _Stat.DEFENSE)
            ? _getPlaceInDefense(id)[_betterThanThisIndex]
            : _getPlaceInSpeed(id)[_betterThanThisIndex];

    return (amountOfCardsBetterThanThis / amountOfOtherCards);
  }

  /// Returns the loss percentage of [PokemonCardData] with
  /// id = [id] in his set if the attack value is to be
  /// compared.
  ///
  /// Calls [_getLossPercentageInStat(id, stat)] with
  /// stat = [_Stat.ATTACK].
  double getLossPercentageInAttack(int id) {
    return _getLossPercentageInStat(id, _Stat.ATTACK);
  }

  /// Returns the loss percentage of [PokemonCardData] with
  /// id = [id] in his set if the defense value is to be
  /// compared.
  ///
  /// Calls [_getLossPercentageInStat(id, stat)] with
  /// stat = [_Stat.DEFENSE].
  double getLossPercentageInDefense(int id) {
    return _getLossPercentageInStat(id, _Stat.DEFENSE);
  }

  /// Returns the loss percentage of [PokemonCardData] with
  /// id = [id] in his set if the speed value is to be
  /// compared.
  ///
  /// Calls [_getLossPercentageInStat(id, stat)] with
  /// stat = [_Stat.SPEED].
  double getLossPercentageInSpeed(int id) {
    return _getLossPercentageInStat(id, _Stat.SPEED);
  }

  /// Calculates the draw percentage of [PokemonCardData] with
  /// id = [id] compared to other cards of [cardSet] under
  /// comparison value of [stat].
  double _getDrawPercentageInStat(int id, _Stat stat) {
    var amountOfOtherCards = cardSet.length - 1;
    var amountOfCardsBetterThanThis = (stat == _Stat.ATTACK)
        ? _getPlaceInAttack(id)[_equalToThisIndex]
        : (stat == _Stat.DEFENSE)
            ? _getPlaceInDefense(id)[_equalToThisIndex]
            : _getPlaceInSpeed(id)[_equalToThisIndex];

    return (amountOfCardsBetterThanThis / amountOfOtherCards);
  }

  /// Returns the draw percentage of [PokemonCardData] with
  /// id = [id] in his set if the attack value is to be
  /// compared.
  ///
  /// Calls [_getDrawPercentageInStat(id, stat)] with
  /// stat = [_Stat.ATTACK].
  double getDrawPercentageInAttack(int id) {
    return _getDrawPercentageInStat(id, _Stat.ATTACK);
  }

  /// Returns the draw percentage of [PokemonCardData] with
  /// id = [id] in his set if the defense value is to be
  /// compared.
  ///
  /// Calls [_getDrawPercentageInStat(id, stat)] with
  /// stat = [_Stat.DEFENSE].
  double getDrawPercentageInDefense(int id) {
    return _getDrawPercentageInStat(id, _Stat.DEFENSE);
  }

  /// Returns the draw percentage of [PokemonCardData] with
  /// id = [id] in his set if the speed value is to be
  /// compared.
  ///
  /// Calls [_getDrawPercentageInStat(id, stat)] with
  /// stat = [_Stat.SPEED].
  double getDrawPercentageInSpeed(int id) {
    return _getDrawPercentageInStat(id, _Stat.SPEED);
  }

  /// Takes a double [value] and returns a string
  /// representation of that value as if it were
  /// a percentage.
  ///
  /// Usually to be called with a [getPercentageIn_XXX_]
  /// call as parameter.
  String percentageString(double value) {
    if (value >= 1)
      return "100%";
    else {
      var stringRepresentation = "$value" +
          "000000000"; // prolong string to prevent errors in substring
      stringRepresentation = stringRepresentation.split(".")[1];
      var toReturn = stringRepresentation.substring(0, 2) +
          ".${stringRepresentation.substring(2, 4)}" +
          "%";
      return (value < 0.1) ? toReturn.substring(1) : toReturn;
    }
  }
}

enum _Stat {
  ATTACK,
  DEFENSE,
  SPEED,
}
