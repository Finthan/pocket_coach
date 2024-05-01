import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../all_class.dart';
import '../../../components/animated_gradient_exmple.dart';
import '../../../constants.dart';
import '../../../info.dart';
import '../../../main.dart';

class ExerciseAlertDialog extends StatefulWidget {
  ExerciseAlertDialog({
    super.key,
    required this.data,
    required this.id,
    required this.fetchExercise,
    required this.onUpdateExercise,
  });

  List<ExerciseList> data;
  final String id;
  final Future<void> Function(dynamic) fetchExercise;
  final Function(List<ExerciseList>) onUpdateExercise;

  @override
  State<ExerciseAlertDialog> createState() => _ExerciseAlertDialogState();
}

class _ExerciseAlertDialogState extends State<ExerciseAlertDialog> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _muscleController = TextEditingController();
  List<Exercises> exercises = [];

  bool _isVisible = false;
  String _isAdd = "";

  bool _isAuth = true;

  @override
  void initState() {
    super.initState();
  }

  Future<List<Exercises>> getExercise() async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'get',
      'object': 'gettutorexercises',
      // 'id': me.id,
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
      if (json.isNotEmpty) {
        setState(() {
          exercises = json
              .map((dynamic e) => Exercises.fromJson(e as Map<String, dynamic>))
              .toList();
        });
      }
    } catch (error) {}
    return exercises;
  }

  Future<void> setExercises(ExerciseList data) async {
    var jsonData = data.toJson();
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'set',
      'object': 'addexercises',
    });
    var response;
    try {
      response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(jsonData));
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Добавить элемент',
        textAlign: TextAlign.center,
      ),
      content: _isVisible ? _buildContentWidget(_isAdd) : _buttomAddExercise(),
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
                        widget.data.add(ExerciseList(
                          id: "0",
                          idWorkout: widget.id,
                          idExercise: "0",
                          nameExercise: _textController.text,
                          muscleGroup: _muscleController.text,
                          ordering: (widget.data.length).toString(),
                        ));
                      });
                      widget.fetchExercise(widget.data);
                      widget.onUpdateExercise(widget.data);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            : Container(),
      ],
    );
  }

  Widget _buttomAddExercise() {
    return SizedBox(
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            child: const Text(
              'Создать упражнение по шаблону',
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              setState(() {
                _isVisible = true;
                _isAdd = "шаблон";
                getExercise();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kWhiteColor,
              maximumSize: const Size(130, 60),
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

  Widget _buildContentWidget(String isAdd) {
    return SizedBox(
      height: 200,
      child: (isAdd == "+")
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
          : FutureBuilder(
              future: getExercise(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Exercises>> snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          for (var i = 0; i < 2; i++)
                            Container(
                              height: 50,
                              width: 200,
                              margin: EdgeInsets.only(
                                left: 20,
                                top: 10,
                                right: (i == 4) ? 20 : 0,
                              ),
                              child: const AnimatedGradientExample(),
                            )
                        ],
                      ),
                    ),
                  );
                } else {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var i = 0; i < exercises.length; i++)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.data.add(ExerciseList(
                                    id: "0",
                                    idWorkout: widget.id,
                                    idExercise: exercises[i].id,
                                    nameExercise: exercises[i].nameExercise,
                                    muscleGroup: exercises[i].muscleGroup,
                                    ordering: (widget.data.length).toString(),
                                  ));
                                });
                                setExercises(ExerciseList(
                                  id: "0",
                                  idWorkout: widget.id,
                                  idExercise: exercises[i].id,
                                  nameExercise: exercises[i].nameExercise,
                                  muscleGroup: exercises[i].muscleGroup,
                                  ordering: (widget.data.length - 1).toString(),
                                ));
                                widget.onUpdateExercise(widget.data);
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                  left: 20,
                                  top: 20,
                                  bottom: 20,
                                ),
                                child: Column(children: <Widget>[
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
                                                  "${exercises[i].nameExercise}\n"
                                                      .toUpperCase(),
                                              style: const TextStyle(
                                                color: kTextColor,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  "${exercises[i].muscleGroup}\n"
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
                                ]),
                              ),
                            )
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
    );
  }
}
