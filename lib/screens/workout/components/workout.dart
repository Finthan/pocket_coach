import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../all_class.dart';
import '../../../constants.dart';
import '../../../main.dart';
import '../../auth_registration.dart/auth_registration_screen.dart';

class Workout extends StatefulWidget {
  const Workout({
    super.key,
    required this.title,
    required this.id,
  });

  final String title;
  final String id;

  @override
  State<Workout> createState() => _WorkoutState();
}

class _WorkoutState extends State<Workout> {
  List<ClientExercise> clientExercise = [];

  int _currentStep = 0;

  int i = 0;
  int countWidget = 6;
  int countWorkout = 1;
  var countTrue = true;

  @override
  void initState() {
    super.initState();
    clientTrainings();
  }

  Future<void> clientTrainings() async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'get',
      'object': 'clientexercise',
      'id_client': clientMe[0].id,
    });
    var response;
    try {
      response = await http.get(uri);
    } catch (error) {
      print('myClients $error');
      return;
    }
    String jsonString = "";
    if (response.statusCode == 200 && isAuth == true) {
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      jsonString = jsonEncode(decodedResponse['data']);
    }
    try {
      final json = await jsonDecode(jsonString) as List<dynamic>;
//print(jsonString);
      if (json.length > 0) {
        setState(() {
          clientExercise = json
              .map((dynamic e) =>
                  ClientExercise.fromJson(e as Map<String, dynamic>))
              .toList();
          countWorkout = clientExercise.length;
        });
      }
    } catch (error) {
      print('ошибка форматирования json myClients $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (countWidget <= 5) {
      setState(() {
        countTrue = false;
      });
    } else {
      setState(() {
        countTrue = true;
      });
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          splashRadius: 20,
          icon: const Icon(Icons.chevron_left),
          iconSize: 30,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Stepper(
        steps: [
          for (i = 0; i < countWorkout; i++)
            Step(
              state: _currentStep >= i && _currentStep < countWorkout
                  ? StepState.complete
                  : StepState.disabled,
              isActive: _currentStep == i,
              title: const Text(
                "Step 1",
                style: TextStyle(color: kWhiteColor),
              ),
              content: Column(
                children: [
                  Container(
                    width: 500,
                    height: 200,
                    decoration: const BoxDecoration(
                      color: kWorkoutColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: const Center(
                      child: Text(
                        "Video",
                        style: TextStyle(color: kWhiteColor),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: countTrue
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.start,
                      children: [
                        for (var j = 0; j < countWidget; j++)
                          Padding(
                            padding: countTrue
                                ? const EdgeInsets.only(right: 0)
                                : const EdgeInsets.only(right: 10),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                color: kWorkoutColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: const Text(
                                "Image",
                                style: TextStyle(color: kWhiteColor),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 5, top: 20),
                    child: const Text(
                      "Вес и колчество повторений: 15 кг, 4 подхода",
                      style: TextStyle(color: kWhiteColor),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 5, top: 15),
                    child: const Text(
                      "Сколько сделал:",
                      style: TextStyle(color: kWhiteColor),
                    ),
                  ),
                ],
              ),
            ),
        ],
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < countWorkout - 1) {
            setState(() {
              _currentStep++;
            });
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep--;
            });
          }
        },
      ),
    );
  }
}
