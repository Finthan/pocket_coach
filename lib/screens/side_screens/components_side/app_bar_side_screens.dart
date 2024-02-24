import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../../../models/rive_asset.dart';
import 'button_back_side_screens.dart';
import 'icon_side_screens.dart';
import 'title_side_screens.dart';

class AppBarSideScreens extends StatelessWidget {
  const AppBarSideScreens({
    super.key,
    required this.riveOnInit,
    required this.menu,
  });

  final ValueChanged<Artboard> riveOnInit;
  final RiveAsset menu;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const ButtonBackSideScreens(),
          TitleSideScreens(
            title: menu.title,
          ),
          IconSideScreens(
            riveOnInit: riveOnInit,
            menu: menu,
          ),
        ],
      ),
    );
  }
}
