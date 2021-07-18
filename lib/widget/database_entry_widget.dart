import 'package:flutter/material.dart';
import 'package:poke_trumps/config/app_colors.dart';
import 'package:poke_trumps/config/neumorph.dart';
import 'package:poke_trumps/data/data.dart';
import 'package:poke_trumps/data/game_history_podo.dart';

/// Widget representation of an entry in our database.
class DatabaseEntryWidget extends StatelessWidget {
  final AppColors appColors = AppColors();
  final NeumorphConstants neumorph = NeumorphConstants();

  final GameHistoryEntry entry;

  /// Basic flexible constructor
  DatabaseEntryWidget({
    @required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: neumorph.neumorphColorBackground,
            boxShadow: [
              BoxShadow(
                blurRadius: neumorph.neumorphNumberBlurRadius,
                offset: Offset(
                  neumorph.neumorphNumberUniversalOffset,
                  neumorph.neumorphNumberUniversalOffset,
                ),
                color: neumorph.neumorphColorDarkShadow,
              ),
              BoxShadow(
                blurRadius: neumorph.neumorphNumberBlurRadius,
                offset: Offset(
                  -neumorph.neumorphNumberUniversalOffset,
                  -neumorph.neumorphNumberUniversalOffset,
                ),
                color: neumorph.neumorphColorLightShadow,
              ),
            ],
          ),
          child: ListTile(
            leading: Image.asset(
              "assets/img/gym/male_chibi.png",
              width: 18,
              height: 29,
              fit: BoxFit.fill,
            ), // 18x29 vs 17x23
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(entry.playerWon ? "Win" : "Loss"),
                Text("Score: ${entry.playerScore}-${entry.opponentScore}"),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Used Set:",
                ),
                Text(NoGlobalVariablesHere().cardSetList[entry.setId].name),
              ],
            ),
            trailing: Image.asset(NoGlobalVariablesHere()
                .opponentList[entry.opponentId]
                .pathToChibiImage),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
