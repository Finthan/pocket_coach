import 'package:flutter/material.dart';
import 'package:pocket_coach/models/rive_asset.dart';

import '../../components_side/app_bar_side_screens.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          AppBarSideScreens(
            menu: sideMenus[2],
            riveOnInit: (artboard) {},
          ),
        ],
      ),
    );
  }
}
