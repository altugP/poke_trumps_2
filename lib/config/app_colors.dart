import 'package:flutter/material.dart';
import 'package:poke_trumps/config/type_colors.dart';
import 'package:poke_trumps/data/pokemon_podo.dart';

/// Class that holds color settings for general
/// app widgets.
///
/// This could have been inside a [ThemeData], but
/// we didn't want to use that.
class AppColors {
  final Color appBarMainColor = Colors.red;
  final Color appBarBottomColor1 = Color(0xFFFF1C1C);
  final Color appBarBottomColor2 = Colors.orange;
  final Color standardTextColor = Colors.black;
  final Color minorTextColor = Color(0x00484848);

  /// Returns the first type color of given [type] to style
  /// the [AppBar].
  ///
  /// Color is predetermined in [globals].
  Color getTypeAppBarColor(PokemonType type) {
    return _getTypeColors(type)[0];
  }

  /// Returns both type colors of given [type] in a
  /// list with only two elements.
  List<Color> _getTypeColors(PokemonType type) {
    final TypeColors typeColors = TypeColors();
    // fallback colors
    var color1 = typeColors.typeColorNone1;
    var color2 = typeColors.typeColorNone2;

    switch (type) {
      case PokemonType.BUG:
        {
          color1 = typeColors.typeColorBug1;
          color2 = typeColors.typeColorBug2;
        }
        break;

      case PokemonType.DARK:
        {
          color1 = typeColors.typeColorDark1;
          color2 = typeColors.typeColorDark2;
        }
        break;

      case PokemonType.DRAGON:
        {
          color1 = typeColors.typeColorDragon1;
          color2 = typeColors.typeColorDragon2;
        }
        break;

      case PokemonType.ELECTRIC:
        {
          color1 = typeColors.typeColorElectric1;
          color2 = typeColors.typeColorElectric2;
        }
        break;

      case PokemonType.FAIRY:
        {
          color1 = typeColors.typeColorFairy1;
          color2 = typeColors.typeColorFairy2;
        }
        break;

      case PokemonType.FIGHTING:
        {
          color1 = typeColors.typeColorFighting1;
          color2 = typeColors.typeColorFighting2;
        }
        break;

      case PokemonType.FIRE:
        {
          color1 = typeColors.typeColorFire1;
          color2 = typeColors.typeColorFire2;
        }
        break;

      case PokemonType.FLYING:
        {
          color1 = typeColors.typeColorFlying1;
          color2 = typeColors.typeColorFlying2;
        }
        break;

      case PokemonType.GHOST:
        {
          color1 = typeColors.typeColorGhost1;
          color2 = typeColors.typeColorGhost2;
        }
        break;

      case PokemonType.GRASS:
        {
          color1 = typeColors.typeColorGrass1;
          color2 = typeColors.typeColorGrass2;
        }
        break;

      case PokemonType.GROUND:
        {
          color1 = typeColors.typeColorGround1;
          color2 = typeColors.typeColorGround2;
        }
        break;

      case PokemonType.ICE:
        {
          color1 = typeColors.typeColorIce1;
          color2 = typeColors.typeColorIce2;
        }
        break;

      case PokemonType.NORMAL:
        {
          color1 = typeColors.typeColorNormal1;
          color2 = typeColors.typeColorNormal2;
        }
        break;

      case PokemonType.POISON:
        {
          color1 = typeColors.typeColorPoison1;
          color2 = typeColors.typeColorPoison2;
        }
        break;

      case PokemonType.PSYCHIC:
        {
          color1 = typeColors.typeColorPsychic1;
          color2 = typeColors.typeColorPsychic2;
        }
        break;

      case PokemonType.ROCK:
        {
          color1 = typeColors.typeColorRock1;
          color2 = typeColors.typeColorRock2;
        }
        break;

      case PokemonType.STEEL:
        {
          color1 = typeColors.typeColorSteel1;
          color2 = typeColors.typeColorSteel2;
        }
        break;

      case PokemonType.WATER:
        {
          color1 = typeColors.typeColorWater1;
          color2 = typeColors.typeColorWater2;
        }
        break;

      default:
        {}
    }

    return [color1, color2];
  }

  /// Returns a two colored [LinearGradient] with the
  /// type colors of given [type].
  ///
  /// Color is predetermined in [globals].
  LinearGradient getTypeGradient(PokemonType type) {
    var colors = _getTypeColors(type);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [0.1, 0.9],
      colors: [
        colors[0],
        colors[1],
      ],
    );
  }
}
