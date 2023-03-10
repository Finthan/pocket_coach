import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../../../components/animated_bar.dart';
import '../../../constants.dart';
import '../../../models/rive_asset.dart';
import '../../../utils/rive_utils.dart';

class MyButtonNavBar extends StatefulWidget {
  const MyButtonNavBar({
    super.key,
  });

  @override
  State<MyButtonNavBar> createState() => _MyButtonNavBarState();
}

class _MyButtonNavBarState extends State<MyButtonNavBar> {
  RiveAsset selectedBottomNav = buttomNavs.first;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: kDefaultPadding * 2,
        right: kDefaultPadding * 2,
        bottom: kDefaultPadding / 4,
      ),
      height: 60,
      decoration: BoxDecoration(
        color: kTextColorBox,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -10),
            blurRadius: 35,
            color: kPrimaryColor.withOpacity(0.38),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ...List.generate(
            buttomNavs.length,
            (index) => GestureDetector(
              onTap: () {
                buttomNavs[index].input!.change(true);
                if (buttomNavs[index] != selectedBottomNav) {
                  setState(() {
                    selectedBottomNav = buttomNavs[index];
                  });
                }
                Future.delayed(const Duration(seconds: 1), () {
                  buttomNavs[index].input!.change(false);
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBar(isActive: buttomNavs[index] == selectedBottomNav),
                  SizedBox(
                    height: 36,
                    width: 36,
                    child: Opacity(
                      opacity: buttomNavs[index] == selectedBottomNav ? 1 : 0.5,
                      child: RiveAnimation.asset(
                        buttomNavs.first.src,
                        artboard: buttomNavs[index].artboard,
                        onInit: (artboard) {
                          StateMachineController controller =
                              RiveUtils.getRiveController(artboard,
                                  stateMachineName:
                                      buttomNavs[index].stateMachineName);
                          buttomNavs[index].input =
                              controller.findSMI("active") as SMIBool;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
