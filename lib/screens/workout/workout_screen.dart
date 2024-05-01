import 'package:flutter/material.dart';

import 'components/body.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({
    super.key,
  });

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  @override
  Widget build(BuildContext context) {
    return const Body();
  }
}
