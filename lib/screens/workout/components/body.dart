import 'package:flutter/material.dart';

import 'list_workout.dart';

class Body extends StatefulWidget {
  const Body({
    super.key,
    required this.name,
    required this.status,
    required this.id,
    required this.age,
    required this.number,
  });

  final String name, status, id, age, number;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          splashRadius: 20,
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Center(
          child: Text(
            "Тренировки",
            style: TextStyle(fontSize: 24),
          ),
        ),
        centerTitle: true,
      ),
      body: ListWorkout(
        id: widget.id,
        age: widget.age,
        number: widget.number,
        name: widget.name,
        status: widget.status,
      ),
    );
  }
}
