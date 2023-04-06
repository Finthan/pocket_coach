import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../info.dart';
import 'list_workout.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: kPrimaryColor,
        title: const Center(
          child: Text(
            "Тренировки",
            style: TextStyle(color: kWiteColor, fontSize: 24),
          ),
        ),
        centerTitle: false,
      ),
      body: ListWorkout(
        training: training,
      ),
    );
  }
}
