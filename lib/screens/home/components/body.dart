import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'coach_woman.dart';
import 'header_with_search_box.dart';
import 'coach_man.dart';
import 'title_with_more_btn.dart';

class Body extends StatefulWidget {
  Body({super.key});

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
            TitleWithMoreBtn(
              title: "Тренер мужчина",
              press: () {},
            ),
            CoachMan(),
            TitleWithMoreBtn(
              title: "Тренер женщина",
              press: () {},
            ),
            CoachWoman(),
            const SizedBox(
              height: kDefaultPadding,
            ),
          ],
        ),
      ),
    );
  }
}
