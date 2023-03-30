import 'package:flutter/material.dart';
import 'package:pocket_coach/models/rive_asset.dart';
import 'package:pocket_coach/screens/side_screens/settings/components/settings_side_tile.dart';
import 'package:rive/rive.dart';

import '../../../../utils/rive_utils.dart';
import '../../components_side/app_bar_side_screens.dart';
import 'title_side_settings_screens.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  RiveAsset selectedMenuL = sideMenus.first;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppBarSideScreens(
            menu: sideMenus[2],
            riveOnInit: (artboard) {},
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TitleSideSettingsScreens(title: 'Основное'),

              /////////////////
              ...sideSettingsScreensIcons.map(
                (menu) => SettingsSideTile(
                  menu: menu,
                  riveonInit: (artboard) {
                    StateMachineController controller =
                        RiveUtils.getRiveController(artboard,
                            stateMachineName: menu.stateMachineName);
                    menu.input = controller.findSMI("active") as SMIBool;
                  },
                  press: () {
                    menu.input!.change(true);
                    Future.delayed(const Duration(seconds: 1), () {
                      menu.input!.change(false);
                    });
                    setState(() {
                      selectedMenuL = menu;
                    });
                  },
                  isActive: selectedMenuL == menu,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
