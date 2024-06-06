import 'package:flutter/material.dart';
import 'package:pocket_coach/models/user_view/my_client_man.dart';
import 'package:pocket_coach/models/user_view/coach_man.dart';
import 'package:provider/provider.dart';

import '../../../all_class.dart';
import '../../../constants.dart';
import '../../../models/user_view/all_client_man.dart';

import 'header_with_search_box.dart';
import 'title_with_more_btn.dart';

class BodyHomeScreen extends StatefulWidget {
  const BodyHomeScreen({super.key});

  @override
  State<BodyHomeScreen> createState() => _BodyHomeScreenState();
}

class _BodyHomeScreenState extends State<BodyHomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<MeModel>(
      builder: (context, meModel, child) {
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
                meModel.isClient ?? false
                    ? Column(children: [
                        TitleWithMoreBtn(
                          title: "Тренера",
                          press: () {},
                        ),
                        CoachMan(size: size),
                      ])
                    : Column(children: [
                        TitleWithMoreBtn(
                          title: "Мои клиенты",
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
      },
    );
  }
}
