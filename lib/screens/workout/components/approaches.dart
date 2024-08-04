import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../all_class.dart';

class Approaches extends StatefulWidget {
  const Approaches({
    super.key,
  });

  @override
  State<Approaches> createState() => _ApproachesState();
}

class _ApproachesState extends State<Approaches> {
  // List<ApproachesList> _data = [];
  // bool _isAuth = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApproachesModel>(
      builder: (context, approachesModel, child) {
        approachesModel.fetchGetApproaches();
        return Scaffold(
          appBar: AppBar(
            title: Text(approachesModel.itemExercise.nameExercise),
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
                  approachesModel.addApproaches(context);
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
                  final item =
                      approachesModel.approachesList.removeAt(oldIndex);
                  approachesModel.approachesList.insert(newIndex, item);
                  for (int i = 0;
                      i < approachesModel.approachesList.length;
                      i++) {
                    approachesModel.approachesList[i].numberApproaches =
                        (i + 1).toString();
                  }
                  approachesModel.fetchSetApproaches();
                });
              },
              children: approachesModel.approachesList
                  .asMap()
                  .map((index, item) => MapEntry(
                        index,
                        ListTile(
                          textColor: Colors.white,
                          iconColor: Colors.white,
                          key: Key('$item$index'),
                          title:
                              Text("Номер подхода: ${item.numberApproaches}"),
                          subtitle: Text(
                              "Вес: ${item.weight} Количество повторений: ${item.countList}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                splashRadius: 20,
                                icon: const Icon(Icons.delete),
                                onPressed: () => approachesModel
                                    .removeItemApproaches(context, index),
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
      },
    );
  }
}
