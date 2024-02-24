import 'package:flutter/material.dart';

import 'components/body.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({
    super.key,
    required this.id,
    required this.name,
    required this.status,
    required this.age,
  });

  final String name, status, id, age;

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Body(
      id: widget.id,
      status: widget.status,
      age: widget.age,
      name: widget.name,
    );
  }
}
