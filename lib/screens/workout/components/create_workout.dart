import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'clients_widget.dart';

class CreateWorkout extends StatefulWidget {
  const CreateWorkout({
    super.key,
    required this.id,
  });

  final String id;

  @override
  State<CreateWorkout> createState() => _CreateWorkoutState();
}

class _CreateWorkoutState extends State<CreateWorkout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          splashRadius: 20,
          icon: const Icon(Icons.chevron_left),
          iconSize: 30,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Создание тренировки"),
        centerTitle: false,
      ),
      body: ClientsWidget(
        id: widget.id,
      ),
    );
  }
}
