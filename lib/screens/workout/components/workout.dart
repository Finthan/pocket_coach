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

  @override
  Widget build(BuildContext context) {
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
          Step(
            state: _currentStep > 0 ? StepState.complete : StepState.disabled,
            isActive: _currentStep == 0,
            title: const Text(
              "Step 1",
              style: TextStyle(color: kWhiteColor),
            ),
            content: Column(
              children: [
                Container(
                  // padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
                  width: 500,
                  height: 400,
                  decoration: const BoxDecoration(
                    color: kWorkoutColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: const Text(
                    "Content step dfndf ndfnd lknfl dknflk df k d n f d k f d k f dkfdkfn 1 ",
                    style: TextStyle(color: kWhiteColor),
                  ),
                ),
              ],
            ),
          ),
          Step(
            state: _currentStep > 1 ? StepState.complete : StepState.disabled,
            isActive: _currentStep == 1,
            title: const Text(
              "Step 2",
              style: TextStyle(color: kWhiteColor),
            ),
            content: Container(
              padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
              width: 500,
              height: 400,
              decoration: const BoxDecoration(
                color: kWorkoutColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: const Text(
                "Content stepdfndfndfndlknfldknflkdfkdnfdkfdkfdkfdkfn 1",
                style: TextStyle(color: kWhiteColor),
              ),
            ),
          ),
          Step(
            state: _currentStep > 2 ? StepState.complete : StepState.disabled,
            isActive: _currentStep == 2,
            title: const Text(
              "Step 3",
              style: TextStyle(color: kWhiteColor),
            ),
            content: Container(
              padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
              width: 500,
              height: 400,
              decoration: const BoxDecoration(
                color: kWorkoutColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: const Text(
                "Content stepdfndfndfndlknfldknflkdfkdnfdkfdkfdkfdkfn 1",
                style: TextStyle(color: kWhiteColor),
              ),
            ),
          ),
          Step(
            state: _currentStep > 3 ? StepState.complete : StepState.disabled,
            isActive: _currentStep == 3,
            title: const Text(
              "Step 4",
              style: TextStyle(color: kWhiteColor),
            ),
            content: Container(
              padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
              width: 500,
              height: 400,
              decoration: const BoxDecoration(
                color: kWorkoutColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: const Text(
                "Content stepdfndfndfndlknfldknflkdfkdnfdkfdkfdkfdkfn 1",
                style: TextStyle(color: kWhiteColor),
              ),
            ),
          ),
          Step(
            state: _currentStep > 4 ? StepState.complete : StepState.disabled,
            isActive: _currentStep == 4,
            title: const Text(
              "Step 5",
              style: TextStyle(color: kWhiteColor),
            ),
            content: Container(
              padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
              width: 500,
              height: 400,
              decoration: const BoxDecoration(
                color: kWorkoutColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: const [
                  Text(
                    "Content s te pdfndfndfndlk nfldknflkdfk dnfdkfdkfd kfdkfn 1",
                    style: TextStyle(color: kWhiteColor),
                  ),
                  Text(
                    "Content stepdfndfndfndlknfldknflkdfkdnfdkfdkfdkfdkfn 1",
                    style: TextStyle(color: kWhiteColor),
                  ),
                  Text(
                    "Content stepdfndfndfndlknfldknflkdfkdnfdkfdkfdkfdkfn 1",
                    style: TextStyle(color: kWhiteColor),
                  ),
                  Text(
                    "Content stepdfndfndfndlknfldknflkdfkdnfdkfdkfdkfdkfn 1",
                    style: TextStyle(color: kWhiteColor),
                  ),
                ],
              ),
            ),
          ),
        ],
        currentStep: _currentStep,
        onStepContinue: () {
          setState(() {
            if (_currentStep != 4) {
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
