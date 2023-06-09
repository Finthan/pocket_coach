import 'package:flutter/material.dart';
import 'package:pocket_coach/screens/app/client_app.dart';
import 'package:pocket_coach/screens/app/tutor_app.dart';
import 'package:pocket_coach/screens/auth_registration.dart/auth_registration_screen.dart';

import '../../constants.dart';
import '../../functions/get_functions.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with SingleTickerProviderStateMixin {
  // late SMIBool isMenuClosed;

  // late AnimationController _animationController;
  // late Animation<double> animation;
  // late Animation<double> scalAnimation;

  // RiveAsset selectedBottomNav = buttomNavs.first;

  // bool isSideMenuClosed = true;

  // @override
  // void initState() {
  //   _animationController = AnimationController(
  //     vsync: this,
  //     duration: const Duration(milliseconds: 200),
  //   )..addListener(() {
  //       setState(() {});
  //     });
  //   animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
  //     parent: _animationController,
  //     curve: Curves.fastOutSlowIn,
  //   ));

  //   scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(
  //     parent: _animationController,
  //     curve: Curves.fastOutSlowIn,
  //   ));
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   _animationController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isClient ? ClientApp() : TutorApp(),
    );
  }
}
