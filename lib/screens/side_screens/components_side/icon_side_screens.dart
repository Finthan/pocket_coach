import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../../../constants.dart';
import '../../../models/rive_asset.dart';

class IconSideScreens extends StatelessWidget {
  const IconSideScreens({
    super.key,
    required this.riveOnInit,
    required this.menu,
  });

  final ValueChanged<Artboard> riveOnInit;
  final RiveAsset menu;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 16, right: 15),
      height: 40,
      width: 40,
      decoration: const BoxDecoration(
        color: kButtonSideScreens,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: kButtonBackSideSrceens,
            offset: Offset(0, 3),
            blurRadius: 8,
          ),
        ],
      ),
      child: RiveAnimation.asset(
        menu.src,
        artboard: menu.artboard,
        onInit: riveOnInit,
      ),
    );
  }
}
