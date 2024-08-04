import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../all_class.dart';

class ApproachesAlertDialog extends StatefulWidget {
  const ApproachesAlertDialog({super.key});

  @override
  State<ApproachesAlertDialog> createState() => _ApproachesAlertDialogState();
}

class _ApproachesAlertDialogState extends State<ApproachesAlertDialog> {
  final TextEditingController _numberApproachesController =
      TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _countController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ApproachesModel>(
        builder: (context, approachesModel, child) {
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
                    fillColor: Colors.grey[200], // задаем фоновый цвет
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
                    fillColor: Colors.grey[200], // задаем фоновый цвет
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
                    fillColor: Colors.grey[200], // задаем фоновый цвет
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
                if (approachesModel.approachesList.length <
                    int.parse(_numberApproachesController.text)) {
                  _numberApproachesController.text =
                      (approachesModel.approachesList.length + 1).toString();
                }
                for (var i = 0;
                    i < approachesModel.approachesList.length;
                    i++) {
                  if (approachesModel.approachesList[i].numberApproaches ==
                      _numberApproachesController.text) {
                    isNotAddNumber = false;
                  }
                }
                if (isNotAddNumber) {
                  approachesModel.approachesList.add(ApproachesList(
                    id: '0',
                    idExerciseWorkout: approachesModel.itemExercise.id,
                    numberApproaches: _numberApproachesController.text,
                    weight: _weightController.text,
                    countList: _countController.text.toString(),
                  ));
                }
                approachesModel.fetchSetApproaches();
              });

              for (int i = 0; i < approachesModel.approachesList.length; i++) {
                approachesModel.approachesList[i].numberApproaches =
                    (i + 1).toString();
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }
}
