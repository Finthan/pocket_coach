import 'package:flutter/material.dart';

import '../../../constants.dart';

class Workout extends StatefulWidget {
  const Workout({
    super.key,
    required this.title,
    required this.id,
  });

  final String title;
  final int id;

  @override
  State<Workout> createState() => _WorkoutState();
}

class _WorkoutState extends State<Workout> {
  int _currentStep = 0;

  int i = 0;
  int countWidget = 6;
  int countWorkout = 6;
  var countTrue = true;

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
              state: _currentStep > i ? StepState.complete : StepState.disabled,
              isActive: _currentStep == i,
              title: const Text(
                "Step 1",
                style: TextStyle(color: kWhiteColor),
              ),
              content: Column(
                children: [
                  Container(
                    // padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
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
          setState(() {
            if (_currentStep != i - 1) {
              _currentStep += 1;
            } else {
              print("Завершение тренировки");
            }
          });
        },
        onStepCancel: () {
          setState(() {
            if (_currentStep != 0) {
              _currentStep -= 1;
            }
          });
        },
      ),
    );
  }
}
