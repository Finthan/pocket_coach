import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pocket_coach/constants.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../all_class.dart';
import '../../auth_registration/auth_registration_screen.dart';

class WorkoutAlertDialog extends StatefulWidget {
  WorkoutAlertDialog({
    super.key,
    required this.id,
    required this.isAuth,
    required this.details,
    required this.trainings,
    required this.onUpdateTrainings,
  });

  final String id;
  final bool isAuth;
  List<Training> trainings;
  final CalendarLongPressDetails details;
  final Function(List<Training>) onUpdateTrainings;

  @override
  State<WorkoutAlertDialog> createState() => _WorkoutAlertDialogState();
}

class _WorkoutAlertDialogState extends State<WorkoutAlertDialog> {
  final _workoutTextController = TextEditingController();

  Future<void> addTrainings(name, time) async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'set',
      'object': 'createworkout',
      'id_tutor': MeModel().me!.idTutor,
      'id_client': widget.id,
      'name_workout': name,
      'workout_date': time,
    });
    dynamic response = await http.get(uri);
    String jsonString = "";
    if (response.statusCode == 200 && widget.isAuth == true) {
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      jsonString = jsonEncode(decodedResponse['data']);
    }
    try {
      final json = jsonDecode(jsonString) as List<dynamic>;
      if (json.isNotEmpty) {
        List<Training> newTrainings = json
            .map((dynamic e) => Training.fromJson(e as Map<String, dynamic>))
            .toList();
        widget.onUpdateTrainings(newTrainings);
      }
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    String buttonText = '';
    var time;
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
            addTrainings(name, time);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
