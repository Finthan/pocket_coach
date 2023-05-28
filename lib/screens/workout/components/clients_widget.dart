import 'package:flutter/material.dart';

import '../../../all_class.dart';
import '../../../constants.dart';
import '../../../functions/get_functions.dart';
import 'client_widget.dart';

class ClientsWidget extends StatefulWidget {
  const ClientsWidget({
    super.key,
  });

  @override
  State<ClientsWidget> createState() => _ClientsWidget();
}

class _ClientsWidget extends State<ClientsWidget>
    with SingleTickerProviderStateMixin {
  final _timeTextController = TextEditingController();
  final _nameExercises1TextController = TextEditingController();
  final _nameExercises2TextController = TextEditingController();
  final _nameExercises3TextController = TextEditingController();
  final _nameExercises4TextController = TextEditingController();
  final _nameExercises5TextController = TextEditingController();

  final _countExercises1TextController = TextEditingController();
  final _countExercises2TextController = TextEditingController();
  final _countExercises3TextController = TextEditingController();
  final _countExercises4TextController = TextEditingController();
  final _countExercises5TextController = TextEditingController();

  final _weightExercises1TextController = TextEditingController();
  final _weightExercises2TextController = TextEditingController();
  final _weightExercises3TextController = TextEditingController();
  final _weightExercises4TextController = TextEditingController();
  final _weightExercises5TextController = TextEditingController();

  final _approachesExercises1TextController = TextEditingController();
  final _approachesExercises2TextController = TextEditingController();
  final _approachesExercises3TextController = TextEditingController();
  final _approachesExercises4TextController = TextEditingController();
  final _approachesExercises5TextController = TextEditingController();

  final _muscleGroupExercises1TextController = TextEditingController();
  final _muscleGroupExercises2TextController = TextEditingController();
  final _muscleGroupExercises3TextController = TextEditingController();
  final _muscleGroupExercises4TextController = TextEditingController();
  final _muscleGroupExercises5TextController = TextEditingController();

  late List<TextEditingController> list = [
    _nameExercises1TextController,
    _nameExercises2TextController,
    _nameExercises3TextController,
    _nameExercises4TextController,
    _nameExercises5TextController,
  ];

  late List<TextEditingController> count = [
    _countExercises1TextController,
    _countExercises2TextController,
    _countExercises3TextController,
    _countExercises4TextController,
    _countExercises5TextController,
  ];

  late List<TextEditingController> weight = [
    _weightExercises1TextController,
    _weightExercises2TextController,
    _weightExercises3TextController,
    _weightExercises4TextController,
    _weightExercises5TextController,
  ];

  late List<TextEditingController> approaches = [
    _approachesExercises1TextController,
    _approachesExercises2TextController,
    _approachesExercises3TextController,
    _approachesExercises4TextController,
    _approachesExercises5TextController,
  ];

  late List<TextEditingController> muscle_group = [
    _muscleGroupExercises1TextController,
    _muscleGroupExercises2TextController,
    _muscleGroupExercises3TextController,
    _muscleGroupExercises4TextController,
    _muscleGroupExercises5TextController,
  ];

  final _countTextController = TextEditingController();
  int _currentStep = 0;

  late AnimationController _animationController;
  late Animation<double> animation;
  late Animation<double> scalAnimation;

  bool isSideMenuClosed = true;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        setState(() {});
      });
    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    ));

    scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    ));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  int i = 0;

  @override
  Widget build(BuildContext context) {
    dynamic listClientForWorkout;
    var countWork = 0;
    var time = "";
    List<String> nameExercises;
    setState(() {
      try {
        countWork = int.parse(_countTextController.text);
        print(countWork);
      } catch (e) {
        print(e);
      }

      try {
        time = _timeTextController.text;
        print(time);
      } catch (e) {
        print(e);
      }

      try {} catch (e) {
        print(e);
      }
    });
    return Stepper(
      steps: [
        Step(
          state: _currentStep > 0 ? StepState.complete : StepState.disabled,
          isActive: _currentStep >= 0,
          title: const Text(
            "Выбор клиента",
            style: TextStyle(color: kWhiteColor),
          ),
          content: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var i = 0; i < listOfClients.length; i++)
                  ClientWidget(
                    title: listOfClients[i].name,
                    press: () {
                      listClientForWorkout = listOfClients[i];
                      print(listClientForWorkout.cardnumber);
                    },
                    age: listOfClients[i].age,
                    cardnumber: listOfClients[i].cardnumber,
                    gender: listOfClients[i].gender,
                  ),
              ],
            ),
          ),
        ),
        Step(
          state: _currentStep > 1 ? StepState.complete : StepState.disabled,
          isActive: _currentStep >= 1,
          title: const Text(
            "Задайте параметры",
            style: TextStyle(color: kWhiteColor),
          ),
          content: Column(
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
                    hintText: "27.05.2023_10:25:00",
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
                    "Напишите количество упражнений",
                    style: TextStyle(color: kWhiteColor, fontSize: 17),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: TextField(
                  controller: _countTextController,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                    hintText: "Напишите количество упражнений",
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
                  controller: list[i],
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
            ],
          ),
        ),
        Step(
          state: _currentStep > 2 ? StepState.complete : StepState.disabled,
          isActive: _currentStep >= 2,
          title: const Text(
            "Выбор упражнений",
            style: TextStyle(color: kWhiteColor),
          ),
          content: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                if (countWork != 0)
                  for (var i = 1; i < countWork + 1; i++)
                    Padding(
                      padding: EdgeInsets.only(left: 18, top: 15, bottom: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 250,
                          width: 200,
                          decoration: BoxDecoration(
                            color: kTextColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 10),
                                blurRadius: 50,
                                color: kPrimaryColor.withOpacity(0.23),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 15, left: 5, right: 5),
                                child: TextField(
                                  controller: list[i],
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 13),
                                    hintText: "Название упражнения",
                                    hintStyle: TextStyle(
                                      color: kTextChat,
                                      fontSize: 13,
                                    ),
                                    isCollapsed: true,
                                    filled: true,
                                  ),
                                  style: const TextStyle(
                                    color: kWhiteColor,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 5, right: 5),
                                child: TextField(
                                  controller: count[i],
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 13),
                                    hintText: "Количество повторений",
                                    hintStyle: TextStyle(
                                      color: kTextChat,
                                      fontSize: 13,
                                    ),
                                    isCollapsed: true,
                                    filled: true,
                                  ),
                                  style: const TextStyle(
                                    color: kWhiteColor,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 5, right: 5),
                                child: TextField(
                                  controller: weight[i],
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 13),
                                    hintText: "Вес",
                                    hintStyle: TextStyle(
                                      color: kTextChat,
                                      fontSize: 13,
                                    ),
                                    isCollapsed: true,
                                    filled: true,
                                  ),
                                  style: const TextStyle(
                                    color: kWhiteColor,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 5, right: 5),
                                child: TextField(
                                  controller: approaches[i],
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 13),
                                    hintText: "Подходы",
                                    hintStyle: TextStyle(
                                      color: kTextChat,
                                      fontSize: 13,
                                    ),
                                    isCollapsed: true,
                                    filled: true,
                                  ),
                                  style: const TextStyle(
                                    color: kWhiteColor,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 5, right: 5),
                                child: TextField(
                                  controller: muscle_group[i],
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 13),
                                    hintText: "Группы мышц",
                                    hintStyle: TextStyle(
                                      color: kTextChat,
                                      fontSize: 13,
                                    ),
                                    isCollapsed: true,
                                    filled: true,
                                  ),
                                  style: const TextStyle(
                                    color: kWhiteColor,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
              ],
            ),
          ),
        ),
        Step(
          state: _currentStep > 3 ? StepState.complete : StepState.disabled,
          isActive: _currentStep >= 3,
          title: const Text(
            "Выбор упражнений2",
            style: TextStyle(color: kWhiteColor),
          ),
          content: Column(
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
                    hintText: "27.05.2023_10:25:00",
                    hintStyle: TextStyle(color: kTextChat),
                    isCollapsed: true,
                    filled: true,
                  ),
                  style: const TextStyle(color: kWhiteColor),
                ),
              ),
            ],
          ),
        ),
      ],
      currentStep: _currentStep,
      onStepContinue: () {
        setState(() {
          if (_currentStep != 3) {
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
    );
  }
}
