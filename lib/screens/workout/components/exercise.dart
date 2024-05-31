import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../all_class.dart';
import 'approaches.dart';

class Exercise extends StatefulWidget {
  const Exercise({
    super.key,
  });

  @override
  State<Exercise> createState() => _ExerciseState();
}

class _ExerciseState extends State<Exercise> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MeModel>(
      builder: (contextModel, meModel, child) {
        meModel.fetchGetExercise();
        return Scaffold(
          appBar: AppBar(
            title: Text(meModel.training.nameWorkout),
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
                  meModel.addExercise(context);
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
                  final item = meModel.data!.removeAt(oldIndex);
                  meModel.data!.insert(newIndex, item);
                  for (int i = 0; i < meModel.data!.length; i++) {
                    meModel.data![i].ordering = i.toString();
                  }
                });
                meModel.fetchExercise();
              },
              children: (meModel.data ?? [])
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
                                onPressed: () => meModel.removeItem(
                                  index,
                                  context,
                                ),
                              ),
                              const Icon(Icons.menu),
                            ],
                          ),
                          onTap: () {
                            if (item.id != "0") {
                              meModel.itemExercise = item;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Approaches(),
                                ),
                              );
                            }
                          },
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
