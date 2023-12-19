import 'package:flutter/material.dart';

import 'chat_workout_button.dart';
import 'image_and_icon.dart';
import 'title_and_age.dart';

class Body extends StatelessWidget {
  const Body({
    super.key,
    required this.image,
    required this.title,
    required this.status,
    required this.age,
    required this.id,
  });

  final String image, title, status, age, id;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ImageAndIcons(
            size: size,
            image: image,
          ),
          TitleAndPrice(
            title: title,
            status: status,
            age: age,
            size: size,
          ),
          ChatWorkoutButton(
            size: size,
            id: id,
          ),
        ],
      ),
    );
  }
}
