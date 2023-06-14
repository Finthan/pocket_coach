import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../../../../constants.dart';
import '../../../../models/rive_asset.dart';
import 'visibility_settings_side.dart';

class SettingsSideTile extends StatelessWidget {
  const SettingsSideTile({
    super.key,
    required this.menu,
    required this.press,
    required this.riveonInit,
    required this.isActive,
    required this.onGlobalVariableChanged,
  });

  final RiveAsset menu;
  final VoidCallback press;
  final ValueChanged<Artboard> riveonInit;
  final bool isActive;
  final VoidCallback onGlobalVariableChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 17, right: 17),
          child: Divider(
            color: kTextColorBox,
            height: 1,
          ),
        ),
        Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              height: 48,
              width: isActive ? 300 : 0,
              child: Container(
                decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
            ),
            ListTile(
              onTap: press,
              leading: SizedBox(
                height: 34,
                width: 34,
                child: RiveAnimation.asset(
                  menu.src,
                  artboard: menu.artboard,
                  onInit: riveonInit,
                ),
              ),
              title: Text(
                menu.title,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        VisibilitySettingsSide(
          isActive: isActive,
          menu: menu,
          onGlobalVariableChanged: () {},
        ),
      ],
    );
  }
}
