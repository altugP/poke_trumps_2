import 'package:flutter/material.dart';
import 'package:poke_trumps/data/data.dart';

/// [Drawer] that shows all used cards of a game.
///
/// Can be accessed in both [PreBattleScreen]s.
class UsedCardsDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var usedCards = NoGlobalVariablesHere().gameData.usedCards;
    return Drawer(
      elevation: 100.0,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Text("Used cards until now:"),
            ),
          ),
          ...usedCards.map(
            (card) => ListTile(
              dense: true,
              leading: Image.asset("assets/icon/type/${card.typeString}.png"),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset(
                    card.pathToAnimation,
                    width: 64,
                    height: 64,
                  ),
                  Text(
                    card.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
