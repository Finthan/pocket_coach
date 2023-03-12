import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../../../../models/rive_asset.dart';
import '../../components_side/app_bar_side_screens.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          AppBarSideScreens(
            riveOnInit: (Artboard value) {},
            menu: sideScreens[1],
          ),
        ],
      ),
    );
  }
}
