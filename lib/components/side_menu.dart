import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../../../constants.dart';
import '../models/rive_asset.dart';
import '../screens/auth_registration/auth_registration_screen.dart';
import '../screens/side_screens/help/help.dart';
import '../screens/side_screens/nutrition_information/nutrition_information.dart';
import '../screens/side_screens/settings/settings.dart';
import '../screens/side_screens/statistics/statistics.dart';
import '../utils/rive_utils.dart';
import 'info_card.dart';
import 'side_menu_tile.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    super.key,
  });

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  RiveAsset selectedMenu = sideMenus.first;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundSideColor,
      body: SizedBox(
        width: 288,
        height: double.infinity,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isClient
                  ? InfoCard(
                      name: clientMe.name,
                      status: clientMe.cardnumber,
                    )
                  : InfoCard(
                      name: tutorMe.name,
                      status: tutorMe.typeOfTraining,
                    ),

              Padding(
                padding: const EdgeInsets.only(left: 17, top: 25, bottom: 15),
                child: Text(
                  "Browse".toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white70),
                ),
              ),
              /////////////////
              ...sideMenus.map(
                (menu) => SideMenuTile(
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
                      selectedMenu = menu;

                      switch (menu.artboard) {
                        case "HOME":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const NutritionInformation(),
                            ),
                          );
                          break;
                        case "CHAT":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Help(),
                            ),
                          );
                          break;
                        case "SETTINGS":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Settings(),
                            ),
                          );
                          break;
                        case "LIKE/STAR":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Statistics(),
                            ),
                          );
                          break;
                      }
                    });
                  },
                  isActive: selectedMenu == menu,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
