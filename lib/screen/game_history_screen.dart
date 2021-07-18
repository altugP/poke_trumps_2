import 'package:flutter/material.dart';
import 'package:poke_trumps/config/app_colors.dart';
import 'package:poke_trumps/config/neumorph.dart';
import 'package:poke_trumps/data/game_history_podo.dart';
import 'package:poke_trumps/widget/database_entry_widget.dart';
import 'package:poke_trumps/widget/transparent_app_bar.dart';

class GameHistoryScreen extends StatefulWidget {
  final List<GameHistoryEntry> entries;

  GameHistoryScreen({@required this.entries});

  @override
  _GameHistoryScreenState createState() => _GameHistoryScreenState();
}

class _GameHistoryScreenState extends State<GameHistoryScreen> {
  final AppColors appColors = AppColors();
  final NeumorphConstants neumorph = NeumorphConstants();

  List<GameHistoryEntry> entryList;

  @override
  void initState() {
    super.initState();
    entryList = widget.entries;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: neumorph.neumorphColorBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: TransparentAppBar().create(
          Text(
            "Match History",
            style: TextStyle(
              color: appColors.standardTextColor,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            ...widget.entries.map((e) => DatabaseEntryWidget(entry: e)),
          ],
        ),
      ),
    );
  }
}
