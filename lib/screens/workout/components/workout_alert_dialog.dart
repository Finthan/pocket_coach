import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../all_class.dart';

class WorkoutAlertDialog extends StatefulWidget {
  const WorkoutAlertDialog({
    super.key,
    required this.details,
  });

  final CalendarLongPressDetails details;

  @override
  State<WorkoutAlertDialog> createState() => _WorkoutAlertDialogState();
}

class _WorkoutAlertDialogState extends State<WorkoutAlertDialog> {
  final _workoutTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<TrainingModel>(builder: (context, trainingModel, child) {
      String time;
      return AlertDialog(
        title: const Text('Добавить тренировку?'),
        content: SizedBox(
          height: 110,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 15, bottom: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Напишите название тренировки",
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: TextField(
                  controller: _workoutTextController,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                    hintText: "Напишите название тренировки",
                    hintStyle: TextStyle(
                      color: Colors.black38,
                      fontSize: 15,
                    ),
                    isCollapsed: true,
                    filled: true,
                  ),
                  style: const TextStyle(color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Отмена',
              style: TextStyle(color: Colors.black38),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text(
              'Добавить',
              style: TextStyle(color: Colors.green),
            ),
            onPressed: () {
              String name = _workoutTextController.text;
              time = widget.details.date
                  .toString()
                  .substring(0, widget.details.date.toString().length - 13);
              trainingModel.fetchAddTrainings(name, time);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }
}
