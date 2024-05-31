import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'all_class.dart';
import 'constants.dart';

class Workout extends StatefulWidget {
  const Workout({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<Workout> createState() => _WorkoutState();
}

class _WorkoutState extends State<Workout> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final widthContext = MediaQuery.of(context).size.width;
    return Consumer<MeModel>(
      builder: (contextModel, meModel, child) {
        meModel.fetchClientTrainings();
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
          body: (meModel.connectionStateWorkout == ConnectionState.waiting)
              ? const Center(child: CircularProgressIndicator())
              : Stepper(
                  currentStep: meModel.currentStep,
                  onStepContinue: meModel.onStepContinue(context),
                  onStepCancel: meModel.onStepCancel,
                  steps: [
                    for (int i = 0; i < meModel.countWorkout; i++)
                      Step(
                        state: meModel.currentStep > i &&
                                meModel.currentStep < meModel.countWorkout
                            ? StepState.complete
                            : StepState.disabled,
                        isActive: meModel.currentStep == i,
                        title: Text(
                          meModel.clientExercise![i].nameExercise,
                          style: const TextStyle(color: kWhiteColor),
                        ),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: widthContext * 0.35,
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Text(
                                    "Подход ${meModel.approachesListClient![meModel.currentStep][meModel.currentSubStep].numberApproaches}",
                                    style: const TextStyle(
                                      color: kNavBarIconColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: widthContext * 0.35,
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Text(
                                    "Количество повторений ${meModel.approachesListClient![meModel.currentStep][meModel.currentSubStep].countList}",
                                    style: const TextStyle(
                                      color: kWhiteColor,
                                    ),
                                    maxLines: 3,
                                  ),
                                ),
                                Container(
                                  width: widthContext * 0.35,
                                  padding: const EdgeInsets.only(
                                    top: 15,
                                    bottom: 15,
                                  ),
                                  child: Text(
                                    "Вес ${meModel.approachesListClient![meModel.currentStep][meModel.currentSubStep].weight}",
                                    style: const TextStyle(color: kWhiteColor),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  width: widthContext * 0.43,
                                  child: const Text(
                                    'Введите количество выполненых повторений',
                                    style: TextStyle(color: kNavBarIconColor),
                                  ),
                                ),
                                SizedBox(
                                  width: widthContext * 0.43,
                                  child: TextField(
                                    style:
                                        const TextStyle(color: kTextFieldColor),
                                    controller: meModel.countDoneApproaches,
                                    decoration: const InputDecoration(
                                      hintText: 'Введите число',
                                      hintStyle: TextStyle(
                                        color: kTextColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                    maxLines: null,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(top: 30),
                                  width: widthContext * 0.43,
                                  child: const Text(
                                    'Введите вес',
                                    style: TextStyle(color: kNavBarIconColor),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  width: widthContext * 0.43,
                                  child: TextField(
                                    style:
                                        const TextStyle(color: kTextFieldColor),
                                    controller: meModel.weightDoneApproaches,
                                    decoration: const InputDecoration(
                                      hintText: 'Введите число',
                                      hintStyle: TextStyle(
                                        color: kTextColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                    maxLines: null,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                  ],
                  controlsBuilder:
                      (BuildContext context, ControlsDetails controlsDetails) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 125,
                          child: ElevatedButton(
                            onPressed: meModel.onStepContinue(context),
                            child: Text((meModel.currentStep ==
                                        meModel.approachesListClient!.length -
                                            1) &&
                                    (meModel.currentSubStep ==
                                        meModel
                                                .approachesListClient![
                                                    meModel.currentStep]
                                                .length -
                                            1)
                                ? 'Готово'
                                : 'Продолжить'),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        if ((meModel.currentStep != 0) ||
                            (meModel.currentSubStep != 0))
                          ElevatedButton(
                            onPressed: controlsDetails.onStepCancel,
                            child: const Text('Назад'),
                          ),
                      ],
                    );
                  },
                ),
        );
      },
    );
  }
}
