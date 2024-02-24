import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../all_class.dart';
import '../../../main.dart';

class Approaches extends StatefulWidget {
  const Approaches({
    super.key,
    required this.item,
  });

  final ExerciseList item;

  @override
  State<Approaches> createState() => _ApproachesState();
}

class _ApproachesState extends State<Approaches> {
  List<ApproachesList> _data = [];
  bool _isAuth = true;

  @override
  void initState() {
    super.initState();
    _isAuth = Main.isAuth;
    getApproaches();
  }

  List<ApproachesList> approaches = [];

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
                  deleteApproaches(index);
                  _data.removeAt(index);
                  for (var i = 0; i < _data.length; i++) {
                    _data[i].numberApproaches = (i + 1).toString();
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteApproaches(i) async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'set',
      'object': 'delapproaches',
      'id': _data[i].id,
      'id_exercise_workout': _data[i].idExerciseWorkout,
    });
    await http.get(uri);

    setState(() {
      try {
        for (var i = 0; i < _data.length; i++) {
          _data[i].numberApproaches = (i + 1).toString();
        }
        fetchApproaches();
      } catch (e) {}
    });
  }

  Future<void> fetchApproaches() async {
    var jsonData = _data.map((aproaches) => aproaches.toJson()).toList();
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'set',
      'object': 'addapproaches',
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
        approaches = json
            .map((dynamic e) =>
                ApproachesList.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (error) {}
      setState(() {
        try {
          _data = approaches;
        } catch (e) {}
      });
    } catch (error) {}
    // for (var i = 0; i < _data.length; i++) {}
  }

  Future<void> getApproaches() async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'get',
      'object': 'getapproaches',
      'id_exercise_workout': widget.item.id,
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
      if (json.length > 0) {
        approaches = json
            .map((dynamic e) =>
                ApproachesList.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (error) {}
    setState(() {
      try {
        _data = approaches;
      } catch (e) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.nameExercise),
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
              // отобразить диалоговое окно для добавления нового элемента
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // контроллер для текстового поля
                  final TextEditingController _numberApproachesController =
                      TextEditingController();
                  final TextEditingController _weightController =
                      TextEditingController();
                  final TextEditingController _countController =
                      TextEditingController();

                  return AlertDialog(
                    title: const Text(
                      'Добавить элемент',
                      textAlign: TextAlign.center,
                    ),
                    content: SizedBox(
                      height: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: Text(
                              "Номер подхода",
                              style: TextStyle(color: Colors.black45),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                            ),
                            child: TextField(
                              controller: _numberApproachesController,
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
                            "Вес",
                            style: TextStyle(color: Colors.black45),
                            textAlign: TextAlign.start,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                              bottom: 5,
                            ),
                            child: TextField(
                              controller: _weightController,
                              style: const TextStyle(color: Colors.black87),
                              decoration: InputDecoration(
                                fillColor:
                                    Colors.grey[200], // задаем фоновый цвет
                                filled: true,
                                // остальные свойства InputDecoration
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              "Количество повторений",
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
                              controller: _countController,
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
                            var isNotAddNumber = true;
                            if (_data.length <
                                int.parse(_numberApproachesController.text)) {
                              _numberApproachesController.text =
                                  (_data.length + 1).toString();
                            }
                            for (var i = 0; i < _data.length; i++) {
                              if (_data[i].numberApproaches ==
                                  _numberApproachesController.text) {
                                isNotAddNumber = false;
                              }
                            }
                            if (isNotAddNumber) {
                              _data.add(ApproachesList(
                                id: '0',
                                idExerciseWorkout: widget.item.id,
                                numberApproaches:
                                    _numberApproachesController.text,
                                weight: _weightController.text,
                                countList: _countController.text.toString(),
                              ));
                            }
                            fetchApproaches();
                          });

                          for (int i = 0; i < _data.length; i++) {
                            _data[i].numberApproaches = (i + 1).toString();
                          }
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
                _data[i].numberApproaches = (i + 1).toString();
              }
              fetchApproaches();
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
                      title: Text("Номер подхода: ${item.numberApproaches}"),
                      subtitle: Text(
                          "Вес: ${item.weight} Количество повторений: ${item.countList}"),
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
                    ),
                  ))
              .values
              .toList(),
        ),
      ),
    );
  }
}
