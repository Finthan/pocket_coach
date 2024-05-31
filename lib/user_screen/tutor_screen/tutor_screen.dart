import 'package:flutter/material.dart';
import 'package:pocket_coach/user_screen/tutor_screen/components/chat_workout_button.dart';
import 'package:pocket_coach/user_screen/tutor_screen/components/image_and_icon.dart';
import 'package:pocket_coach/user_screen/tutor_screen/components/title_and_age.dart';

class TutorScreen extends StatelessWidget {
  const TutorScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ImageAndIcons(size: size),
            TitleAndPrice(size: size),
            ChatWorkoutButton(size: size),
          ],
        ),
      ),
    );
  }
}
