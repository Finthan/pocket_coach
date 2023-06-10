import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../models/client_man.dart';
import '../../../models/coach_man.dart';
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
                ? Column(
                    children: [
                      TitleWithMoreBtn(
                        title: "Тренера",
                        press: () {},
                      ),
                      const CoachMan()
                    ],
                  )
                : Column(
                    children: [
                      TitleWithMoreBtn(
                        title: "Все клиенты",
                        press: () {},
                      ),
                      const ClientMan(),
                      TitleWithMoreBtn(
                        title: "Остальные клиенты",
                        press: () {},
                      ),
                      const ClientMan(),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
