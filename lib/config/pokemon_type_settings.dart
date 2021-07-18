import 'package:poke_trumps/data/pokemon_podo.dart';

/// This class defines all [PokemonType] interactions.
class PokemonTypeSettings {
  /// Displays a [PokemonType] with a list of all opponents
  /// that are weak to that type.
  final Map<PokemonType, List<PokemonType>> typeStrengths = {
    PokemonType.NONE: [],
    PokemonType.BUG: [PokemonType.GRASS, PokemonType.DARK, PokemonType.PSYCHIC],
    PokemonType.DARK: [PokemonType.GHOST, PokemonType.PSYCHIC],
    PokemonType.DRAGON: [PokemonType.DRAGON],
    PokemonType.ELECTRIC: [PokemonType.FLYING, PokemonType.WATER],
    PokemonType.FAIRY: [
      PokemonType.FIGHTING,
      PokemonType.DARK,
      PokemonType.DRAGON
    ],
    PokemonType.FIGHTING: [
      PokemonType.DARK,
      PokemonType.ICE,
      PokemonType.NORMAL,
      PokemonType.ROCK,
      PokemonType.STEEL
    ],
    PokemonType.FIRE: [
      PokemonType.BUG,
      PokemonType.GRASS,
      PokemonType.ICE,
      PokemonType.STEEL
    ],
    PokemonType.FLYING: [
      PokemonType.BUG,
      PokemonType.FIGHTING,
      PokemonType.GRASS
    ],
    PokemonType.GHOST: [PokemonType.GHOST, PokemonType.PSYCHIC],
    PokemonType.GRASS: [
      PokemonType.GROUND,
      PokemonType.ROCK,
      PokemonType.WATER
    ],
    PokemonType.GROUND: [
      PokemonType.ELECTRIC,
      PokemonType.FIRE,
      PokemonType.POISON,
      PokemonType.ROCK,
      PokemonType.STEEL
    ],
    PokemonType.ICE: [
      PokemonType.DRAGON,
      PokemonType.FLYING,
      PokemonType.GRASS,
      PokemonType.GROUND
    ],
    PokemonType.NORMAL: [], // LUL
    PokemonType.POISON: [PokemonType.FAIRY, PokemonType.GRASS],
    PokemonType.PSYCHIC: [PokemonType.FIGHTING, PokemonType.POISON],
    PokemonType.ROCK: [
      PokemonType.BUG,
      PokemonType.FIRE,
      PokemonType.FLYING,
      PokemonType.ICE
    ],
    PokemonType.STEEL: [PokemonType.FAIRY, PokemonType.ICE, PokemonType.ROCK],
    PokemonType.WATER: [PokemonType.FIRE, PokemonType.GROUND, PokemonType.ROCK],
  };

  /// Displays a [PokemonType] with a list of all opponents
  /// that are strong against that type.
  final Map<PokemonType, List<PokemonType>> typeWeaknesses = {
    PokemonType.NONE: [],
    PokemonType.BUG: [
      PokemonType.FIRE,
      PokemonType.FAIRY,
      PokemonType.FIGHTING,
      PokemonType.POISON,
      PokemonType.FLYING,
      PokemonType.GHOST,
      PokemonType.STEEL,
    ],
    PokemonType.DARK: [
      PokemonType.FIGHTING,
      PokemonType.DARK,
      PokemonType.FAIRY,
    ],
    PokemonType.DRAGON: [
      PokemonType.STEEL,
    ],
    PokemonType.ELECTRIC: [
      PokemonType.ELECTRIC,
      PokemonType.GRASS,
      PokemonType.DRAGON,
    ],
    PokemonType.FAIRY: [
      PokemonType.POISON,
      PokemonType.STEEL,
      PokemonType.FIRE,
    ],
    PokemonType.FIGHTING: [
      PokemonType.POISON,
      PokemonType.FLYING,
      PokemonType.PSYCHIC,
      PokemonType.BUG,
      PokemonType.FAIRY,
    ],
    PokemonType.FIRE: [
      PokemonType.FIRE,
      PokemonType.WATER,
      PokemonType.ROCK,
      PokemonType.DRAGON,
    ],
    PokemonType.FLYING: [
      PokemonType.ELECTRIC,
      PokemonType.ROCK,
      PokemonType.STEEL,
    ],
    PokemonType.GHOST: [
      PokemonType.DARK,
    ],
    PokemonType.GRASS: [
      PokemonType.FIRE,
      PokemonType.GRASS,
      PokemonType.POISON,
      PokemonType.FLYING,
      PokemonType.BUG,
      PokemonType.DRAGON,
      PokemonType.STEEL,
    ],
    PokemonType.GROUND: [
      PokemonType.GRASS,
      PokemonType.BUG,
    ],
    PokemonType.ICE: [
      PokemonType.FIRE,
      PokemonType.WATER,
      PokemonType.ICE,
      PokemonType.STEEL,
    ],
    PokemonType.NORMAL: [
      PokemonType.ROCK,
      PokemonType.STEEL,
    ],
    PokemonType.POISON: [
      PokemonType.POISON,
      PokemonType.GROUND,
      PokemonType.ROCK,
      PokemonType.GHOST,
    ],
    PokemonType.PSYCHIC: [
      PokemonType.PSYCHIC,
      PokemonType.STEEL,
    ],
    PokemonType.ROCK: [
      PokemonType.FIGHTING,
      PokemonType.GROUND,
      PokemonType.STEEL,
    ],
    PokemonType.STEEL: [
      PokemonType.FIRE,
      PokemonType.WATER,
      PokemonType.ELECTRIC,
      PokemonType.STEEL,
    ],
    PokemonType.WATER: [
      PokemonType.WATER,
      PokemonType.GRASS,
      PokemonType.DRAGON,
    ],
  };

  /// Displays a [PokemonType] with a list of all opponents
  /// that take no damage from that type.
  final Map<PokemonType, List<PokemonType>> typeIneffectivenesses = {
    PokemonType.NONE: [],
    PokemonType.BUG: [],
    PokemonType.DARK: [],
    PokemonType.DRAGON: [PokemonType.FAIRY],
    PokemonType.ELECTRIC: [PokemonType.GROUND],
    PokemonType.FAIRY: [],
    PokemonType.FIGHTING: [PokemonType.GHOST],
    PokemonType.FIRE: [],
    PokemonType.FLYING: [],
    PokemonType.GHOST: [PokemonType.NORMAL],
    PokemonType.GRASS: [],
    PokemonType.GROUND: [PokemonType.FLYING],
    PokemonType.ICE: [],
    PokemonType.NORMAL: [PokemonType.GHOST],
    PokemonType.POISON: [PokemonType.STEEL],
    PokemonType.PSYCHIC: [PokemonType.DARK],
    PokemonType.ROCK: [],
    PokemonType.STEEL: [],
    PokemonType.WATER: [],
  };
}
