import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'featured_plants.dart';
import 'header_with_search_box.dart';
import 'recomends_plants.dart';
import 'title_with_more_btn.dart';

class Body extends StatelessWidget {
  const Body({super.key});

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
              title: "Рекомендованный",
              press: () {},
            ),
            const RecomendsPlants(),
            TitleWithMoreBtn(title: "Рекомендуемые Растения", press: () {}),
            const FeaturedPlants(),
            const SizedBox(
              height: kDefaultPadding,
            ),
          ],
        ),
      ),
    );
  }
}
