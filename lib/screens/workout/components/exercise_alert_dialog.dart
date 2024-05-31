import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../all_class.dart';
import '../../../constants.dart';

class ExerciseAlertDialog extends StatefulWidget {
  const ExerciseAlertDialog({super.key});

  @override
  State<ExerciseAlertDialog> createState() => _ExerciseAlertDialogState();
}

class _ExerciseAlertDialogState extends State<ExerciseAlertDialog> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _muscleController = TextEditingController();

  bool _isVisible = false;
  String _isAdd = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print("вкл");
    return Consumer<MeModel>(
      builder: (contextModel, meModel, child) {
        return AlertDialog(
          title: const Text(
            'Добавить элемент',
            textAlign: TextAlign.center,
          ),
          content: _isVisible
              ? _buildContentWidget(meModel)
              : _buttomAddExercise(meModel),
          contentPadding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          actions: [
            (_isAdd == "+")
                ? Row(
                    children: [
                      TextButton(
                        child: const Text('Отмена'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Добавить'),
                        onPressed: () {
                          setState(() {
                            meModel.data!.add(ExerciseList(
                              id: "0",
                              idWorkout: meModel.training.id,
                              idExercise: "0",
                              nameExercise: _textController.text,
                              muscleGroup: _muscleController.text,
                              ordering: (meModel.data!.length).toString(),
                            ));
                          });
                          meModel.fetchExercise();
                          meModel.updateExercise(meModel.data!);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  )
                : Container(),
          ],
        );
      },
    );
  }

  Widget _buttomAddExercise(MeModel meModel) {
    return SizedBox(
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isVisible = true;
                _isAdd = "шаблон";
                meModel.fetchGetTutorExercise();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kWhiteColor,
              maximumSize: const Size(130, 60),
            ),
            child: const Text(
              'Создать упражнение по шаблону',
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: const Center(child: Icon(Icons.add)),
            onPressed: () {
              setState(() {
                _isVisible = true;
                _isAdd = "+";
              });
            },
            style: ElevatedButton.styleFrom(
              elevation: 3,
              backgroundColor: kWhiteColor,
              minimumSize: const Size(30, 60),
              maximumSize: const Size(100, 60),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentWidget(MeModel meModel) {
    return Consumer<MeModel>(
      builder: (contextModel, meModel, child) {
        meModel.fetchGetTutorExercise();
        return SizedBox(
          height: 200,
          child: (_isAdd == "+")
              ? Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(
                        "Название упражнения",
                        style: TextStyle(color: Colors.black45),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 5,
                      ),
                      child: TextField(
                        controller: _textController,
                        style: const TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          fillColor: Colors.grey[200], // задаем фоновый цвет
                          filled: true,
                        ),
                      ),
                    ),
                    const Text(
                      "Задействованная мышца",
                      style: TextStyle(color: Colors.black45),
                      textAlign: TextAlign.start,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 5,
                      ),
                      child: TextField(
                        controller: _muscleController,
                        style: const TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          fillColor: Colors.grey[200],
                          filled: true,
                        ),
                      ),
                    ),
                  ],
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (meModel.listExercises != null)
                          for (var i = 0;
                              i < meModel.listExercises!.length;
                              i++)
                            GestureDetector(
                              onTap: () {
                                setState(
                                  () {
                                    meModel.data!.add(
                                      ExerciseList(
                                        id: "0",
                                        idWorkout: meModel.training.id,
                                        idExercise:
                                            meModel.listExercises![i].id,
                                        nameExercise: meModel
                                            .listExercises![i].nameExercise,
                                        muscleGroup: meModel
                                            .listExercises![i].muscleGroup,
                                        ordering:
                                            (meModel.data!.length).toString(),
                                      ),
                                    );
                                  },
                                );
                                meModel.fetchExercises(ExerciseList(
                                  id: "0",
                                  idWorkout: meModel.training.id,
                                  idExercise: meModel.listExercises![i].id,
                                  nameExercise:
                                      meModel.listExercises![i].nameExercise,
                                  muscleGroup:
                                      meModel.listExercises![i].muscleGroup,
                                  ordering:
                                      (meModel.data!.length - 1).toString(),
                                ));
                                meModel.updateExercise(meModel.data!);
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                  left: 20,
                                  top: 20,
                                  bottom: 20,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height: 100,
                                      width: 200,
                                      padding: const EdgeInsets.all(
                                          kDefaultPadding / 2),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: const Offset(0, 10),
                                            blurRadius: 50,
                                            color:
                                                kPrimaryColor.withOpacity(0.23),
                                          ),
                                        ],
                                      ),
                                      child: SizedBox(
                                        width: 140,
                                        height: 50,
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    "${meModel.listExercises![i].nameExercise}\n"
                                                        .toUpperCase(),
                                                style: const TextStyle(
                                                  color: kTextColor,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    "${meModel.listExercises![i].muscleGroup}\n"
                                                        .toUpperCase(),
                                                style: TextStyle(
                                                  color: kPrimaryColor
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
