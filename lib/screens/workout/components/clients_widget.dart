import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../constants.dart';
import '../../auth_registration.dart/auth_registration_screen.dart';

class ClientsWidget extends StatefulWidget {
  const ClientsWidget({
    super.key,
    required this.id,
  });

  final String id;

  @override
  State<ClientsWidget> createState() => _ClientsWidget();
}

class _ClientsWidget extends State<ClientsWidget>
    with SingleTickerProviderStateMixin {
  final _timeTextController = TextEditingController();
  final _workoutTextController = TextEditingController();

  var countWork = 0;
  var time = "";
  var nameWorkout = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 200),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 18, top: 15, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Введите дату тренировки",
                style: TextStyle(color: kWhiteColor, fontSize: 17),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: TextField(
              controller: _timeTextController,
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                hintText: "2023-05-28",
                hintStyle: TextStyle(color: kTextChat),
                isCollapsed: true,
                filled: true,
              ),
              style: const TextStyle(color: kWhiteColor),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 18, top: 15, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Напишите название тренировки",
                style: TextStyle(color: kWhiteColor, fontSize: 17),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: TextField(
              controller: _workoutTextController,
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                hintText: "Напишите название тренировки",
                hintStyle: TextStyle(
                  color: kTextChat,
                  fontSize: 15,
                ),
                isCollapsed: true,
                filled: true,
              ),
              style: const TextStyle(color: kWhiteColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
            child: TextButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  )),
                  backgroundColor: MaterialStateProperty.all(kPrimaryColor)),
              onPressed: () {
                setState(() {
                  time = _timeTextController.text;
                  nameWorkout = _workoutTextController.text;
                  Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
                    'apiv': '1',
                    'action': 'set',
                    'object': 'createworkout',
                    'id_tutor': tutorMe.id,
                    'id_client': widget.id,
                    'name_workout': nameWorkout,
                    'workout_date': time,
                  });
                  dynamic auth = http.get(uri);
                  Navigator.pop(context);
                });
              },
              child: const Text(
                "Создать тренировку",
                style: TextStyle(color: kWhiteColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
