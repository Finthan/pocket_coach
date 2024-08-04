import 'package:flutter/material.dart';

import 'chat_workout_button.dart';
import 'image_and_icon.dart';
import 'title_and_age.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ImageAndIcons(
            size: size,
          ),
          TitleAndPrice(
            size: size,
          ),
          ChatWorkoutButton(
            size: size,
          ),
        ],
      ),
    );
  }
}
