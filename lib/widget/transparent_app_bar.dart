import 'package:flutter/material.dart';
import 'package:poke_trumps/config/app_colors.dart';

/// This class is used as holder class for the
/// [create] method.
class TransparentAppBar {
  final AppColors appColors = AppColors();
  final double colorStripHeight = 5.0;

  Widget createSliver(Widget title, {List<Widget> actions, TabBar tabBar}) {
    final colorStrip = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            appColors.appBarBottomColor1,
            appColors.appBarBottomColor2,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      height: colorStripHeight,
    );

    return SliverAppBar(
      iconTheme: IconThemeData(color: appColors.standardTextColor),
      actions: actions ?? <Widget>[],
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: title,
      bottom: PreferredSize(
        child: Column(
          children: <Widget>[
            colorStrip,
            tabBar ?? Container(),
          ],
        ),
        preferredSize: Size.fromHeight(
          (tabBar != null) ? tabBar.preferredSize.height : colorStripHeight,
        ),
      ),
    );
  }

  /// Creates a transparent [AppBar] with an
  /// accent strip at its bottom.
  Widget create(Widget title,
      {List<Widget> actions, TabBar tabBar, bool leading}) {
    final colorStrip = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            appColors.appBarBottomColor1,
            appColors.appBarBottomColor2,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      height: colorStripHeight,
    );

    return AppBar(
      automaticallyImplyLeading: leading ?? true,
      iconTheme: IconThemeData(color: appColors.standardTextColor),
      actions: actions ?? <Widget>[],
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: title,
      bottom: PreferredSize(
        child: Column(
          children: <Widget>[
            colorStrip,
            tabBar ?? Container(),
          ],
        ),
        preferredSize: Size.fromHeight(
          (tabBar != null) ? tabBar.preferredSize.height : colorStripHeight,
        ),
      ),
    );
  }
}
