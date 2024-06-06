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
    return Consumer<MeModel>(
      builder: (context, meModel, child) {
        meModel.fetchGetApproaches();
        return Scaffold(
          appBar: AppBar(
            title: Text(meModel.itemExercise.nameExercise),
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
                  meModel.addApproaches(context);
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
                  final item = meModel.approachesList!.removeAt(oldIndex);
                  meModel.approachesList!.insert(newIndex, item);
                  for (int i = 0; i < meModel.approachesList!.length; i++) {
                    meModel.approachesList![i].numberApproaches =
                        (i + 1).toString();
                  }
                  meModel.fetchSetApproaches();
                });
              },
              children: (meModel.approachesList != null)
                  ? meModel.approachesList!
                      .asMap()
                      .map((index, item) => MapEntry(
                            index,
                            ListTile(
                              textColor: Colors.white,
                              iconColor: Colors.white,
                              key: Key('$item$index'),
                              title: Text(
                                  "Номер подхода: ${item.numberApproaches}"),
                              subtitle: Text(
                                  "Вес: ${item.weight} Количество повторений: ${item.countList}"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    splashRadius: 20,
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => meModel
                                        .removeItemApproaches(context, index),
                                  ),
                                  const Icon(Icons.menu),
                                ],
                              ),
                            ),
                          ))
                      .values
                      .toList()
                  : [],
            ),
          ),
        );
      },
    );
  }
}
