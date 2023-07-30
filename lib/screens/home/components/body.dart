import 'package:flutter/material.dart';
import 'package:pocket_coach/models/user_view/my_client_man.dart';
import 'package:pocket_coach/models/user_view/coach_man.dart';

import '../../../constants.dart';
import '../../../models/user_view/all_client_man.dart';
import '../../auth_registration.dart/auth_registration_screen.dart';

import 'header_with_search_box.dart';
import 'title_with_more_btn.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 40,
              color: kPrimaryColor,
            ),
            HeaderWithSearchBox(size: size),
            isClient
                ? Column(children: [
                    TitleWithMoreBtn(
                      title: "Тренера",
                      press: () {},
                    ),
                    CoachMan(size: size)
                  ])
                : Column(children: [
                    TitleWithMoreBtn(
                      title: "Все клиенты",
                      press: () {},
                    ),
                    MyClientMan(size: size),
                    TitleWithMoreBtn(
                      title: "Остальные клиенты",
                      press: () {},
                    ),
                    AllClientMan(size: size)
                  ])
          ],
        ),
      ),
    );
  }
}
