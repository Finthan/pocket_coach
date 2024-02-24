import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../all_class.dart';
import '../../../main.dart';
import 'approaches.dart';

class Exercise extends StatefulWidget {
  const Exercise({
    super.key,
    required this.training,
  });

  final Training training;

  @override
  State<Exercise> createState() => _ExerciseState();
}

dynamic exerciseList = 'строка не изменена';

class _ExerciseState extends State<Exercise> {
  List<ExerciseList> _data = [];

  bool _isAuth = true;

  @override
  void initState() {
    super.initState();

    _isAuth = Main.isAuth;
    getExercise();
  }

  void _removeItem(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтверждение удаления'),
          content: const Text('Вы действительно хотите удалить этот элемент?'),
          actions: [
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Удалить'),
              onPressed: () {
                setState(() {
                  deleteExercise(index);
                  _data.removeAt(index);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteExercise(index) async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'set',
      'object': 'delexercise',
      'id': _data[index].id,
      'id_exercise': _data[index].idExercise,
      'id_workout': _data[index].idWorkout,
    });
    await http.get(uri);

    setState(() {
      try {
        for (var i = 0; i < _data.length; i++) {
          _data[i].ordering = (i).toString();
        }
        fetchExercise();
      } catch (e) {}
    });
  }

  Future<void> fetchExercise() async {
    var jsonData = _data.map((exercise) => exercise.toJson()).toList();
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'set',
      'object': 'addexercise',
    });
    var response;
    try {
      response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(jsonData));

      String jsonString = "";
      if (response.statusCode == 200 && _isAuth == true) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map;
        jsonString = jsonEncode(decodedResponse['data']);
      }
      try {
        final json = await jsonDecode(jsonString) as List<dynamic>;
        if (json.isNotEmpty) {
          exercises = json
              .map((dynamic e) =>
                  ExerciseList.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      } catch (error) {}
      setState(() {
        try {
          _data = exercises;
          exercises = [];
          getExercise();
        } catch (e) {}
      });
    } catch (error) {}
  }

  List<ExerciseList> exercises = [];

  Future<void> getExercise() async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'get',
      'object': 'getexercise',
      'id_workout': widget.training.id.toString(),
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
        exercises = json
            .map(
                (dynamic e) => ExerciseList.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (error) {}
    setState(() {
      try {
        _data = exercises;
        exercises = [];
      } catch (e) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.training.nameWorkout),
        leading: IconButton(
          splashRadius: 20,
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            splashRadius: 20,
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  final TextEditingController _textController =
                      TextEditingController();
                  final TextEditingController _muscleController =
                      TextEditingController();

                  return AlertDialog(
                    title: const Text(
                      'Добавить элемент',
                      textAlign: TextAlign.center,
                    ),
                    content: SizedBox(
                      height: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                                fillColor:
                                    Colors.grey[200], // задаем фоновый цвет
                                filled: true,
                                // остальные свойства InputDecoration
                              ),
                            ),
                          ),
                          const Text(
                            "Задействованая мышца",
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
                                fillColor:
                                    Colors.grey[200], // задаем фоновый цвет
                                filled: true,
                                // остальные свойства InputDecoration
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
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
                            // добавить новый элемент в список
                            _data.add(ExerciseList(
                              id: "0",
                              idWorkout: widget.training.id,
                              idExercise: "0",
                              nameExercise: _textController.text,
                              muscleGroup: _muscleController.text,
                              ordering: (_data.length).toString(),
                            ));
                          });
                          fetchExercise();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          left: 5,
          right: 5,
          bottom: 10,
        ),
        child: ReorderableListView(
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }
              final item = _data.removeAt(oldIndex);
              _data.insert(newIndex, item);
              for (int i = 0; i < _data.length; i++) {
                _data[i].ordering = i.toString();
              }
              fetchExercise();
            });
          },
          children: _data
              .asMap()
              .map((index, item) => MapEntry(
                    index,
                    ListTile(
                      textColor: Colors.white,
                      iconColor: Colors.white,
                      key: Key('$item$index'),
                      title: Text(item.nameExercise),
                      subtitle: Text(item.muscleGroup),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            splashRadius: 20,
                            icon: const Icon(Icons.delete),
                            onPressed: () => _removeItem(index),
                          ),
                          const Icon(Icons.menu),
                        ],
                      ),
                      onTap: () {
                        print(item.id);
                        if (item.id != "0")
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Approaches(item: item),
                            ),
                          );
                      },
                    ),
                  ))
              .values
              .toList(),
        ),
      ),
    );
  }
}
