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

  bool _isAuth = true;

  @override
  void initState() {
    super.initState();
    _isAuth = Main.isAuth;
    clientTrainings();
  }

  Future<void> clientTrainings() async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'get',
      'object': 'clientexercise',
      'id_workout': widget.id,
    });
    var response;
    try {
      response = await http.get(uri);
    } catch (error) {
      print('myClients $error');
      return;
    }
    String jsonString = "";
    if (response.statusCode == 200 && _isAuth == true) {
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      jsonString = jsonEncode(decodedResponse['data']);
    }
    print(jsonString);
    try {
      final json = await jsonDecode(jsonString) as List<dynamic>;
      if (json.isNotEmpty) {
        setState(() {
          clientExercise = json
              .map((dynamic e) =>
                  ClientExercise.fromJson(e as Map<String, dynamic>))
              .toList();
          countWorkout = clientExercise.length;
          print("количество $countWorkout");
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
      body: clientExercise.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Stepper(
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
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                padding:
                                    const EdgeInsets.only(left: 5, top: 20),
                                child: Text(
                                  clientExercise[i].nameExercise,
                                  style: const TextStyle(color: kWhiteColor),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding:
                                    const EdgeInsets.only(left: 5, top: 15),
                                child: Text(
                                  clientExercise[i].muscleGroup,
                                  style: const TextStyle(color: kWhiteColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          splashRadius: 20,
                          onPressed: () {},
                          icon: const Icon(
                            Icons.add_sharp,
                            size: 20,
                            color: Colors.white,
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
