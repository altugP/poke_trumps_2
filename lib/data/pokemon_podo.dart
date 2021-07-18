import 'package:flutter/foundation.dart';

/// Enum to hold all pokemon types.
///
/// A Pokemon always has to have a type, it can't have [PokemonType.none].
/// [PokemonType.none] is reserved for Pokeball cards, since using null is bad.
/// The effect of all these types can be looked up on [https://pokemondb.net/type]
/// (last checked: 2019-12-24T16:51:23+0000)
enum PokemonType {
  NONE, // for pokeballs
  BUG,
  DARK,
  DRAGON,
  ELECTRIC,
  FAIRY,
  FIGHTING,
  FIRE,
  FLYING,
  GHOST,
  GRASS,
  GROUND,
  ICE,
  NORMAL,
  POISON,
  PSYCHIC,
  ROCK,
  STEEL,
  WATER
}

/// Data structure that holds all information on a Pokemon Card.
class PokemonCardData {
  final int setID;
  final int id;
  final String name;
  final String pathToImage;
  final String typeString;
  final int attackValue;
  final int defenseValue;
  final int speedValue;
  final String pathToAnimation;

  /// Standard flexible constructor.
  PokemonCardData({
    @required this.setID,
    @required this.id,
    @required this.name,
    @required this.pathToImage,
    @required this.typeString,
    @required this.attackValue,
    @required this.defenseValue,
    @required this.speedValue,
    @required this.pathToAnimation,
  });

  /// Factory Constructor to create a [PokemonCardData] from a json Map.
  ///
  /// This constructor gathers information from the map and calls the regular
  /// constructor with said information. [json] has to be a [Map], converting
  /// a json string to a map has to be made outside of this constructor.
  factory PokemonCardData.fromJson(Map<String, dynamic> json) {
    var card = PokemonCardData(
      setID: json["set_id"],
      id: json["id"],
      name: json["name"],
      pathToImage: json["image"],
      typeString: json["pokemon_type"],
      attackValue: json["pokemon_values"]["attack"],
      defenseValue: json["pokemon_values"]["defense"],
      speedValue: json["pokemon_values"]["speed"],
      pathToAnimation: json["pokemon_animation"],
    );
    return card;
  }

  /// This returns the actual [PokemonType] of this card.
  ///
  /// For a string representation use [this.typeString].
  PokemonType get pokemonType => _getPokemonTypeFromString(typeString);

  /// Json representation of this object in form of a [Map<String, dynamic>].
  ///
  /// The map can be converted to a json string via [dart:convert].
  /// The resulting json string will look exactly like an entry in the
  /// set file of the origin of this object.
  Map<String, dynamic> toJson() {
    var map = Map<String, dynamic>();
    map["set_id"] = setID;
    map["id"] = id;
    map["name"] = name;
    map["image"] = pathToImage;
    map["pokemon_type"] = typeString;
    map["pokemon_values"] = Map<String, dynamic>();
    map["pokemon_values"]["attack"] = attackValue;
    map["pokemon_values"]["defense"] = defenseValue;
    map["pokemon_values"]["speed"] = speedValue;
    map["pokemon_animation"] = pathToAnimation;

    return map;
  }

  @override
  String toString() => toJson().toString();
}

/// A method to determine the actual [PokemonType] from a given String.
///
/// This is extremely tedious, but dart leaves us no choice. An enum in
/// dart is always in the form of EnumName.ENUM like [PokemonType.BUG].
/// This method takes the part after the dot, turns it into upper case and
/// compares that to [pokemonTypeString] in upper case.
///
/// This method is private and only visible to this file.
PokemonType _getPokemonTypeFromString(String pokemonTypeString) {
  return PokemonType.values.firstWhere((element) =>
      element.toString().split(".")[1].toUpperCase() ==
      pokemonTypeString.toUpperCase());
}
