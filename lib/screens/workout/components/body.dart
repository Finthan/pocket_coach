import 'package:flutter/material.dart';

import 'list_workout.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Center(
          child: Text(
            "Тренировки",
            style: TextStyle(fontSize: 24),
          ),
        ),
        centerTitle: false,
      ),
      body: const ListWorkout(),
    );
  }
}
