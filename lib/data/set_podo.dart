import 'package:flutter/foundation.dart';
import 'package:poke_trumps/data/pokemon_podo.dart';

/// Data Class that holds all information on a card set.
///
/// Data representation of a json file inside [assets/set/].
class CardSet {
  final int id;
  final String name;
  final String description;
  final String pathToImage;
  final List<PokemonCardData> cards;

  int get size => (cards ?? []).length;

  /// Standard constructor
  CardSet({
    @required this.id,
    @required this.description,
    @required this.name,
    @required this.pathToImage,
    @required this.cards,
  });

  @override
  String toString() {
    return "SET_ID: $id, NAME: $name, DESCRIPTION: $description, IMAGE: $pathToImage, CARDS_NOT_NULL: ${cards != null}";
  }
}
