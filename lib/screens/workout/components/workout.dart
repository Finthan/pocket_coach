import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../all_class.dart';
import '../../../constants.dart';

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
  late TrainingModel trainingModel;
  late ApproachesModel approachesModel;
  final TextEditingController _countDoneApproaches = TextEditingController();
  final TextEditingController _weightDoneApproaches = TextEditingController();

  int _currentStep = 0;
  int _currentSubStep = 0;

  int i = 0;

  @override
  void initState() {
    super.initState();
    trainingModel = Provider.of<TrainingModel>(context, listen: false);
    approachesModel = Provider.of<ApproachesModel>(context, listen: false);
    approachesModel.fetchClientTrainings();
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Закончить прохождение тренировки",
            style: TextStyle(color: Colors.black87),
          ),
          content: const Text(
            "Отменить сохранение тренировки нельзя!",
            style: TextStyle(color: Colors.black54),
          ),
          actions: [
            TextButton(
              child: const Text("Отмена"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Сохранить"),
              onPressed: () {
                approachesModel.fetchApproachers();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final widthContext = MediaQuery.of(context).size.width;
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
      body: FutureBuilder(
        future: approachesModel.clientTrainings(),
        builder: (BuildContext context,
            AsyncSnapshot<List<List<ApproachesList>>> snapshot) {
          if (approachesModel.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Stepper(
              currentStep: _currentStep,
              onStepContinue: _onStepContinue,
              onStepCancel: _onStepCancel,
              steps: [
                for (i = 0; i < trainingModel.countWorkout; i++)
                  Step(
                    state: _currentStep > i &&
                            _currentStep < trainingModel.countWorkout
                        ? StepState.complete
                        : StepState.disabled,
                    isActive: _currentStep == i,
                    title: Text(
                      approachesModel.clientExercise[i].nameExercise,
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
                                "Подход ${approachesModel.dataApproachesList[_currentStep][_currentSubStep].numberApproaches}",
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
                                "Количество повторений ${approachesModel.dataApproachesList[_currentStep][_currentSubStep].countList}",
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
                                "Вес ${approachesModel.dataApproachesList[_currentStep][_currentSubStep].weight}",
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
                                style: const TextStyle(color: kTextFieldColor),
                                controller: _countDoneApproaches,
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
                                style: const TextStyle(color: kTextFieldColor),
                                controller: _weightDoneApproaches,
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
                  ),
              ],
              controlsBuilder:
                  (BuildContext context, ControlsDetails controlsDetails) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 125,
                      child: ElevatedButton(
                        onPressed: _onStepContinue,
                        child: Text((_currentStep ==
                                    approachesModel.dataApproachesList.length -
                                        1) &&
                                (_currentSubStep ==
                                    approachesModel
                                            .dataApproachesList[_currentStep]
                                            .length -
                                        1)
                            ? 'Готово'
                            : 'Продолжить'),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    if ((_currentStep != 0) || (_currentSubStep != 0))
                      ElevatedButton(
                        onPressed: controlsDetails.onStepCancel,
                        child: const Text('Назад'),
                      ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }

  void _onStepContinue() {
    if (_currentSubStep <
        approachesModel.dataApproachesList[_currentStep].length - 1) {
      setState(() {
        if (_weightDoneApproaches.text != '' &&
            _countDoneApproaches.text != '') {
          if (approachesModel.information.length <= _currentStep) {
            approachesModel.information.add([]);
          }
          if (_currentSubStep ==
              approachesModel.information[_currentStep].length) {
            approachesModel.information[_currentStep].add(
              MadeApproachesList(
                idApproaches: approachesModel
                    .dataApproachesList[_currentStep][_currentSubStep].id,
                weight: _weightDoneApproaches.text,
                countList: _countDoneApproaches.text,
              ),
            );
          } else {
            approachesModel.information[_currentStep][_currentSubStep] =
                MadeApproachesList(
              idApproaches: approachesModel
                  .dataApproachesList[_currentStep][_currentSubStep].id,
              weight: _weightDoneApproaches.text,
              countList: _countDoneApproaches.text,
            );
          }
          _currentSubStep++;
          trainingModel.currentData =
              approachesModel.dataApproachesList[_currentStep][_currentSubStep];
          if (approachesModel.information[_currentStep].length >
              _currentSubStep) {
            _countDoneApproaches.text = approachesModel
                .information[_currentStep][_currentSubStep].countList;
            _weightDoneApproaches.text = approachesModel
                .information[_currentStep][_currentSubStep].weight;
          } else {
            _countDoneApproaches.clear();
            _weightDoneApproaches.clear();
          }
        }
      });
    } else {
      if (_currentStep < approachesModel.dataApproachesList.length - 1) {
        setState(() {
          if (_weightDoneApproaches.text != '' &&
              _countDoneApproaches.text != '') {
            if (_currentSubStep ==
                approachesModel.information[_currentStep].length) {
              approachesModel.information[_currentStep].add(
                MadeApproachesList(
                  idApproaches: approachesModel
                      .dataApproachesList[_currentStep][_currentSubStep].id,
                  weight: _weightDoneApproaches.text,
                  countList: _countDoneApproaches.text,
                ),
              );
            } else {
              approachesModel.information[_currentStep][_currentSubStep] =
                  MadeApproachesList(
                idApproaches: approachesModel
                    .dataApproachesList[_currentStep][_currentSubStep].id,
                weight: _weightDoneApproaches.text,
                countList: _countDoneApproaches.text,
              );
            }
            if ((approachesModel.information[_currentStep].length - 1 ==
                    _currentSubStep) &&
                (approachesModel.information.length > _currentStep + 1)) {
              if (approachesModel.information[_currentStep + 1].isNotEmpty) {
                _countDoneApproaches.text =
                    approachesModel.information[_currentStep + 1][0].countList;
                _weightDoneApproaches.text =
                    approachesModel.information[_currentStep + 1][0].weight;
              }
            } else {
              _countDoneApproaches.clear();
              _weightDoneApproaches.clear();
            }
            _currentStep++;
            _currentSubStep = 0;
            trainingModel.currentData = approachesModel
                .dataApproachesList[_currentStep][_currentSubStep];
          }
        });
      } else {
        if (_weightDoneApproaches.text != '' &&
            _countDoneApproaches.text != '') {
          if (_currentSubStep >
              approachesModel.information[_currentStep].length - 1) {
            approachesModel.information[_currentStep].add(
              MadeApproachesList(
                idApproaches: approachesModel
                    .dataApproachesList[_currentStep][_currentSubStep].id,
                weight: _weightDoneApproaches.text,
                countList: _countDoneApproaches.text,
              ),
            );
          } else {
            approachesModel.information[_currentStep][_currentSubStep] =
                MadeApproachesList(
              idApproaches: approachesModel
                  .dataApproachesList[_currentStep][_currentSubStep].id,
              weight: _weightDoneApproaches.text,
              countList: _countDoneApproaches.text,
            );
          }
          if (approachesModel.information[_currentStep].length >
              _currentSubStep) {
            _countDoneApproaches.text = approachesModel
                .information[_currentStep][_currentSubStep].countList;
            _weightDoneApproaches.text = approachesModel
                .information[_currentStep][_currentSubStep].weight;
          } else {
            _countDoneApproaches.clear();
            _weightDoneApproaches.clear();
          }
          _showDialog();
        }
      }
    }
  }

  void _onStepCancel() {
    if (_currentSubStep > 0) {
      setState(() {
        _currentSubStep--;
        trainingModel.currentData =
            approachesModel.dataApproachesList[_currentStep][_currentSubStep];
        _countDoneApproaches.text = approachesModel
            .information[_currentStep][_currentSubStep].countList;
        _weightDoneApproaches.text =
            approachesModel.information[_currentStep][_currentSubStep].weight;
      });
    } else if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        _currentSubStep =
            approachesModel.dataApproachesList[_currentStep].length - 1;
        trainingModel.currentData =
            approachesModel.dataApproachesList[_currentStep][_currentSubStep];
        _countDoneApproaches.text = approachesModel
            .information[_currentStep][_currentSubStep].countList;
        _weightDoneApproaches.text =
            approachesModel.information[_currentStep][_currentSubStep].weight;
      });
    }
  }
}
