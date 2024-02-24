import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../all_class.dart';
import '../../../constants.dart';
import '../../../main.dart';

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
  final TextEditingController _countDoneApproaches = TextEditingController();
  final TextEditingController _weightDoneApproaches = TextEditingController();
  ConnectionState _connectionState = ConnectionState.waiting;

  List<ClientExercise> clientExercise = [];

  final List<List<ApproachesList>> _data = [];

  List<List<MadeApproachesList>> information = [];

  int _currentStep = 0;
  int _currentSubStep = 0;

  ApproachesList _currentData = ApproachesList(
    id: '',
    idExerciseWorkout: '',
    countList: '',
    numberApproaches: '',
    weight: '',
  );

  int i = 0;
  int countWorkout = 0;

  bool _isAuth = true;

  @override
  void initState() {
    super.initState();
    _isAuth = Main.isAuth;
    clientTrainings();
  }

  Future<List<List<ApproachesList>>> clientTrainings() async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'get',
      'object': 'clientexercise',
      'id_workout': widget.id,
    });
    var response;
    try {
      response = await http.get(uri);
    } catch (error) {}
    String jsonString = "";
    if (response.statusCode == 200 && _isAuth == true) {
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      jsonString = jsonEncode(decodedResponse['data']);
    }
    try {
      final json = await jsonDecode(jsonString) as List<dynamic>;
      print(json);
      if (json.isNotEmpty) {
        setState(() {
          clientExercise = json
              .map((dynamic e) => ClientExercise.fromJson(
                    e as Map<String, dynamic>,
                  ))
              .toList();
          countWorkout = clientExercise.length;
        });
      }
    } catch (error) {}

    var index = 0;
    for (var element in clientExercise) {
      Uri uriApproaches = Uri.http('gymapp.amadeya.net', '/api.php', {
        'apiv': '1',
        'action': 'get',
        'object': 'getapproaches',
        'id_exercise_workout': element.id,
      });
      var responseApproaches;
      try {
        responseApproaches = await http.get(uriApproaches);
      } catch (error) {
        // return;
      }
      String jsonStringApproaches = "";
      if (responseApproaches.statusCode == 200 && _isAuth == true) {
        var decodedResponseApproaches =
            jsonDecode(utf8.decode(responseApproaches.bodyBytes)) as Map;
        jsonStringApproaches = jsonEncode(decodedResponseApproaches['data']);
      }
      try {
        final json = await jsonDecode(jsonStringApproaches) as List<dynamic>;

        if (json.isNotEmpty) {
          if (_data.length <= index) {
            _data.add([]);
            setState(() {
              _data[index].addAll(json
                  .map((dynamic e) =>
                      ApproachesList.fromJson(e as Map<String, dynamic>))
                  .toList());
            });
          }
          index++;
        }
      } catch (error) {}
    }
    setState(() {
      if (clientExercise.isNotEmpty && _data.isNotEmpty) {
        _connectionState = ConnectionState.done;
      }
    });
    return _data;
  }

  Future<void> fetchApproachers() async {
    List<List<Map<String, dynamic>>> jsonData = information
        .map<List<Map<String, dynamic>>>((infoList) => infoList
            .map<Map<String, dynamic>>((info) => info.toJson())
            .toList())
        .toList();

    String jsonString = jsonEncode(jsonData);
    print(jsonString);

    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'set',
      'object': 'madeapproaches',
    });
    var response;
    response = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(jsonData));
    print(utf8.decode(response.bodyBytes));
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
                fetchApproachers();
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
        future: clientTrainings(),
        builder: (BuildContext context,
            AsyncSnapshot<List<List<ApproachesList>>> snapshot) {
          if (_connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Stepper(
              currentStep: _currentStep,
              onStepContinue: _onStepContinue,
              onStepCancel: _onStepCancel,
              steps: [
                for (i = 0; i < countWorkout; i++)
                  Step(
                    state: _currentStep > i && _currentStep < countWorkout
                        ? StepState.complete
                        : StepState.disabled,
                    isActive: _currentStep == i,
                    title: Text(
                      clientExercise[i].nameExercise,
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
                                "Подход ${_data[_currentStep][_currentSubStep].numberApproaches}",
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
                                "Количество повторений ${_data[_currentStep][_currentSubStep].countList}",
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
                                "Вес ${_data[_currentStep][_currentSubStep].weight}",
                                style: const TextStyle(color: kWhiteColor),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(
                              width: widthContext * 0.43,
                              child: Text(
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
                        child: Text((_currentStep == _data.length - 1) &&
                                (_currentSubStep ==
                                    _data[_currentStep].length - 1)
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
    if (_currentSubStep < _data[_currentStep].length - 1) {
      setState(() {
        if (_weightDoneApproaches.text != '' &&
            _countDoneApproaches.text != '') {
          if (information.length <= _currentStep) {
            information.add([]);
          }
          if (_currentSubStep == information[_currentStep].length) {
            information[_currentStep].add(
              MadeApproachesList(
                idApproaches: _data[_currentStep][_currentSubStep].id,
                weight: _weightDoneApproaches.text,
                countList: _countDoneApproaches.text,
              ),
            );
          } else {
            information[_currentStep][_currentSubStep] = MadeApproachesList(
              idApproaches: _data[_currentStep][_currentSubStep].id,
              weight: _weightDoneApproaches.text,
              countList: _countDoneApproaches.text,
            );
          }
          _currentSubStep++;
          _currentData = _data[_currentStep][_currentSubStep];
          if (information[_currentStep].length > _currentSubStep) {
            _countDoneApproaches.text =
                information[_currentStep][_currentSubStep].countList;
            _weightDoneApproaches.text =
                information[_currentStep][_currentSubStep].weight;
          } else {
            _countDoneApproaches.clear();
            _weightDoneApproaches.clear();
          }
        }
      });
    } else {
      if (_currentStep < _data.length - 1) {
        setState(() {
          if (_weightDoneApproaches.text != '' &&
              _countDoneApproaches.text != '') {
            if (_currentSubStep == information[_currentStep].length) {
              information[_currentStep].add(
                MadeApproachesList(
                  idApproaches: _data[_currentStep][_currentSubStep].id,
                  weight: _weightDoneApproaches.text,
                  countList: _countDoneApproaches.text,
                ),
              );
            } else {
              information[_currentStep][_currentSubStep] = MadeApproachesList(
                idApproaches: _data[_currentStep][_currentSubStep].id,
                weight: _weightDoneApproaches.text,
                countList: _countDoneApproaches.text,
              );
            }
            print("${information[_currentStep].length - 1} $_currentSubStep");
            print("${information.length} ${_currentStep + 1}");
            if ((information[_currentStep].length - 1 == _currentSubStep) &&
                (information.length > _currentStep + 1)) {
              if (information[_currentStep + 1].length > 0) {
                _countDoneApproaches.text =
                    information[_currentStep + 1][0].countList;
                _weightDoneApproaches.text =
                    information[_currentStep + 1][0].weight;
              }
            } else {
              _countDoneApproaches.clear();
              _weightDoneApproaches.clear();
            }
            _currentStep++;
            _currentSubStep = 0;
            _currentData = _data[_currentStep][_currentSubStep];
          }
        });
      } else {
        if (_weightDoneApproaches.text != '' &&
            _countDoneApproaches.text != '') {
          if (_currentSubStep > information[_currentStep].length - 1) {
            information[_currentStep].add(
              MadeApproachesList(
                idApproaches: _data[_currentStep][_currentSubStep].id,
                weight: _weightDoneApproaches.text,
                countList: _countDoneApproaches.text,
              ),
            );
          } else {
            information[_currentStep][_currentSubStep] = MadeApproachesList(
              idApproaches: _data[_currentStep][_currentSubStep].id,
              weight: _weightDoneApproaches.text,
              countList: _countDoneApproaches.text,
            );
          }
          if (information[_currentStep].length > _currentSubStep) {
            _countDoneApproaches.text =
                information[_currentStep][_currentSubStep].countList;
            _weightDoneApproaches.text =
                information[_currentStep][_currentSubStep].weight;
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
        _currentData = _data[_currentStep][_currentSubStep];
        _countDoneApproaches.text =
            information[_currentStep][_currentSubStep].countList;
        _weightDoneApproaches.text =
            information[_currentStep][_currentSubStep].weight;
      });
    } else if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        _currentSubStep = _data[_currentStep].length - 1;
        _currentData = _data[_currentStep][_currentSubStep];
        _countDoneApproaches.text =
            information[_currentStep][_currentSubStep].countList;
        _weightDoneApproaches.text =
            information[_currentStep][_currentSubStep].weight;
      });
    }
  }
}
