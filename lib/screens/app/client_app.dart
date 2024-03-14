import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pocket_coach/screens/home/home_screen.dart';
import 'package:pocket_coach/screens/workout/workout_screen.dart';
import 'package:rive/rive.dart';

import '../../components/animated_bar.dart';
import '../../components/side_menu.dart';
import '../../constants.dart';
import '../../models/rive_asset.dart';
import '../../models/side_menu_button.dart';
import '../../utils/rive_utils.dart';

class ClientApp extends StatefulWidget {
  const ClientApp({
    super.key,
  });

  @override
  State<ClientApp> createState() => _ClientAppState();
}

List navBarButton = [
  const HomeScreen(),
  const WorkoutScreen(
    id: '',
    status: '',
    number: '',
    name: '',
    age: '',
  ),
];

class _ClientAppState extends State<ClientApp>
    with SingleTickerProviderStateMixin {
  late SMIBool isMenuClosed;

  late AnimationController _animationController;
  late Animation<double> animation;
  late Animation<double> scalAnimation;

  RiveAsset selectedBottomNav = buttomNavs.first;

  bool isSideMenuClosed = true;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        setState(() {});
      });
    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    ));

    scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    ));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundSideColor,
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            width: 288,
            left: isSideMenuClosed ? -288 : 0,
            height: MediaQuery.of(context).size.height,
            child: const SideMenu(),
          ),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(animation.value - 30 * animation.value * pi / 180),
            child: Transform.translate(
              offset: Offset(animation.value * 265, 0),
              child: Transform.scale(
                scale: scalAnimation.value,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                      Radius.circular(isSideMenuClosed ? 0 : 25)),
                  child: navBarButton[numberScreen],
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            left: isSideMenuClosed ? 0 : 220,
            top: 15,
            child: SideMenuButton(
              riveOnInit: (artboard) {
                StateMachineController controller = RiveUtils.getRiveController(
                    artboard,
                    stateMachineName: "State Machine");
                isMenuClosed = controller.findSMI("isOpen") as SMIBool;
                isMenuClosed.value = true;
              },
              press: () {
                if (isSideMenuClosed) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
                isMenuClosed.value = !isMenuClosed.value;
                setState(() {
                  isSideMenuClosed = isMenuClosed.value;
                });
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Transform.translate(
        offset: Offset(0, 100 * animation.value),
        child: Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ...List.generate(
                buttomNavs.length,
                (index) => GestureDetector(
                  onTap: () {
                    buttomNavs[index].input!.change(true);
                    if (buttomNavs[index] != selectedBottomNav) {
                      setState(() {
                        selectedBottomNav = buttomNavs[index];
                        numberScreen = index;
                      });
                    }
                    Future.delayed(const Duration(seconds: 1), () {
                      buttomNavs[index].input!.change(false);
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedBar(
                          isActive: buttomNavs[index] == selectedBottomNav),
                      SizedBox(
                        height: 36,
                        width: 36,
                        child: Opacity(
                          opacity:
                              buttomNavs[index] == selectedBottomNav ? 1 : 0.5,
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
        ),
      ),
    );
  }
}
