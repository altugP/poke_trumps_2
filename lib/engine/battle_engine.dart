import 'package:flutter/foundation.dart';
import 'package:poke_trumps/config/pokemon_type_settings.dart';
import 'package:poke_trumps/data/pokemon_podo.dart';
import 'package:poke_trumps/screen/battle_screen.dart';

class StatEngine {
  final PokemonCardData playerCard;
  final PokemonCardData opponentCard;
  final int valueToCompare; // see BattleScreen
  final int statBoostStrongAgainst = 3;
  final int statBoostWeakAgainst = 1;

  /// Flexible constructor
  StatEngine({
    @required this.playerCard,
    @required this.opponentCard,
    @required this.valueToCompare,
  });

  int get playerStat => _calculateBattleState()[0];
  int get opponentStat => _calculateBattleState()[1];
  PokemonCardData get winner {
    var list = _calculateBattleState();
    return (list[0] > list[1])
        ? playerCard
        : (list[0] < list[1]) ? opponentCard : null;
  }

  /// Returns [card]'s appropriate value to compare.
  ///
  /// Convention: See [BattleScreen]
  int _getComparisonStat(PokemonCardData card) {
    if (valueToCompare == BattleScreen.attackValue) return card.attackValue;
    if (valueToCompare == BattleScreen.defenseValue) return card.defenseValue;
    if (valueToCompare == BattleScreen.speedValue) return card.speedValue;

    return 0; // shouldn't happen
  }

  /// Calculates the new stat value of [playerCard] after
  /// type bonusses against [opponentCard].
  ///
  /// [defaultValue] should be [playerCard]'s actual stat
  /// before calculations.
  int _calculateNewCardStat(
    PokemonCardData playerCard,
    PokemonCardData opponentCard,
    int defaultValue,
  ) {
    var stats = PokemonTypeSettings();
    var stat = (stats.typeIneffectivenesses[playerCard.pokemonType]
            .contains(opponentCard.pokemonType))
        ? 0
        : (stats.typeStrengths[playerCard.pokemonType]
                .contains(opponentCard.pokemonType))
            ? defaultValue + statBoostStrongAgainst
            : (stats.typeWeaknesses[playerCard.pokemonType]
                    .contains(opponentCard.pokemonType))
                ? defaultValue - statBoostWeakAgainst
                : defaultValue;

    return stat;
  }

  /// Returns a list of both new stat values after type bonus.
  ///
  /// Index 0 => new player stat
  /// Index 1 => new opponent stat
  List<int> _calculateBattleState() {
    var playerStat = _getComparisonStat(playerCard);
    var opponentStat = _getComparisonStat(opponentCard);

    // calculate new stat values
    playerStat = _calculateNewCardStat(
      playerCard,
      opponentCard,
      playerStat,
    );
    opponentStat = _calculateNewCardStat(
      opponentCard,
      playerCard,
      opponentStat,
    );

    return <int>[playerStat, opponentStat];
  }
}
