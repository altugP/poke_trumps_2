import 'package:flutter/foundation.dart';

/// PODO class for the base opponents.
class Opponent {
  final int id;
  final String name;
  final String pathToMainImage;
  final String pathToChibiImage;
  final String backStory;
  final Difficulty difficulty;

  /// Basic flexible constructor
  Opponent(
      {@required this.id,
      @required this.name,
      @required this.difficulty,
      @required this.backStory,
      @required this.pathToMainImage,
      @required this.pathToChibiImage});
}

//! this really should've been used more aggressively.
enum Difficulty {
  EASY,
  MEDIUM,
  HARD,
}
