import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

import '../../../constants.dart';
import '../all_class.dart';
import '../models/rive_asset.dart';
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
    return Consumer<MeModel>(builder: (context, meModel, child) {
      String name = meModel.me.name;
      String? cardnumber = meModel.me.cardnumber;
      String? typeOfTraining = meModel.me.typeOfTraining;
      return Scaffold(
        backgroundColor: kBackgroundSideColor,
        body: SizedBox(
          width: 288,
          height: double.infinity,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoCard(
                  name: name,
                  status: cardnumber ?? typeOfTraining ?? "Null",
                ),
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
                          // case "HOME":
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) =>
                          //           const NutritionInformation(),
                          //     ),
                          //   );
                          //   break;
                          // case "CHAT":
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => const Help(),
                          //     ),
                          //   );
                          //   break;
                          case "SETTINGS":
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Settings(),
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
    });
  }
}
