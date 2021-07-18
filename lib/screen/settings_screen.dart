import 'package:flutter/material.dart';
import 'package:poke_trumps/config/app_colors.dart';
import 'package:poke_trumps/config/neumorph.dart';
import 'package:poke_trumps/data/data.dart';
import 'package:poke_trumps/data/preferences_constants.dart';
import 'package:poke_trumps/data/set_podo.dart';
import 'package:poke_trumps/widget/transparent_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This screen allows the user to persistently store settings
/// like the image of the card backs on the device.
///
/// Persistency is achieved by calling SharedPreferences / NSUSerDefaults.
class SettingsScreen extends StatefulWidget {
  final String initialSleevePath;
  final int initialSetId;

  SettingsScreen({this.initialSleevePath, this.initialSetId});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AppColors appColors = AppColors();
  final NeumorphConstants neumorph = NeumorphConstants();

  String activeCardPath;
  int activeSetId;

  @override
  void initState() {
    super.initState();

    activeCardPath = widget.initialSleevePath;
    activeSetId = widget.initialSetId;
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
            "Settings",
            style: TextStyle(
                fontSize: 24,
                color: appColors.standardTextColor,
                fontWeight: FontWeight.w500),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "Choose your preferred Card Sleeve",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Expanded(
              child: _buildCardSleeveSelection(),
            ),
            Divider(),
            Expanded(
              child: _buildSetSelection(),
            ),
          ],
        ),
      ),
    );
  }

  /// Returns  a simple row displaying the active card
  /// sleeve and a [ListView] of [Card]s to change that.
  Widget _buildCardSleeveSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(activeCardPath),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: <Widget>[
              _buildCardSelectorWidget("Card Sleeve Basic",
                  "assets/img/sleeve/card_sleeve_basic.png"),
              _buildCardSelectorWidget("Card Sleeve Alola",
                  "assets/img/sleeve/card_sleeve_alola.png"),
              _buildCardSelectorWidget("Card Sleeve Galar",
                  "assets/img/sleeve/card_sleeve_galar.png"),
              _buildCardSelectorWidget("Card Sleeve Hoenn",
                  "assets/img/sleeve/card_sleeve_hoenn.png"),
              _buildCardSelectorWidget("Card Sleeve Jotho",
                  "assets/img/sleeve/card_sleeve_jotho.png"),
              _buildCardSelectorWidget("Card Sleeve Sinnoh",
                  "assets/img/sleeve/card_sleeve_sinnoh.png"),
              _buildCardSelectorWidget("Card Sleeve Unova",
                  "assets/img/sleeve/card_sleeve_unova.png"),
            ],
          ),
        ),
      ],
    );
  }

  /// Returns a [Card] displaying given information [sleeveName].
  ///
  /// Contains a [Radio] that changes [activeCardPath] to [pathToSleeveImage]
  /// and stores that choice in [SharedPreferences].
  Widget _buildCardSelectorWidget(String sleeveName, String pathToSleeveImage) {
    return Card(
      elevation: 20,
      color: neumorph.neumorphColorBackground,
      child: Container(
        child: ListTile(
          leading: Radio(
            value: pathToSleeveImage,
            onChanged: (value) async {
              var prefs = await SharedPreferences.getInstance();
              await prefs.setString(PrefsConstants.cardSleevePrefsKey, value);
              setState(() => activeCardPath = value);
            },
            activeColor: appColors.appBarMainColor,
            groupValue: activeCardPath,
          ),
          title: Text(sleeveName),
          dense: true,
        ),
      ),
    );
  }

  Widget _buildSetSelection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          "Choose your preferred Card Set",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildSetSelectorWidget(0),
            _buildSetSelectorWidget(1),
          ],
        ),
      ],
    );
  }

  Widget _buildSetSelectorWidget(int setId) {
    final double size = 180;
    final double imageSize = 90;
    final CardSet cardSet = NoGlobalVariablesHere().cardSetList[setId];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          color: neumorph.neumorphColorBackground,
          boxShadow: [
            BoxShadow(
              color: neumorph.neumorphColorDarkShadow,
              blurRadius: neumorph.neumorphNumberBlurRadius,
              offset: Offset(
                neumorph.neumorphNumberUniversalOffset,
                neumorph.neumorphNumberUniversalOffset,
              ),
            ),
            BoxShadow(
              color: neumorph.neumorphColorLightShadow,
              blurRadius: neumorph.neumorphNumberBlurRadius,
              offset: Offset(
                -neumorph.neumorphNumberUniversalOffset,
                -neumorph.neumorphNumberUniversalOffset,
              ),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Set ${cardSet.id + 1}"),
              Image.asset(
                cardSet.pathToImage,
                width: imageSize,
                height: imageSize,
              ),
              Radio(
                value: setId,
                onChanged: (value) async {
                  var prefs = await SharedPreferences.getInstance();
                  await prefs.setInt(PrefsConstants.cardSetPrefsKey, value);
                  setState(() => activeSetId = value);
                },
                activeColor: appColors.appBarMainColor,
                groupValue: activeSetId,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
