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
    return Consumer<ExerciseModel>(
      builder: (context, exerciseModel, child) {
        exerciseModel.fetchGetExercise();
        return Scaffold(
          appBar: AppBar(
            title: Text(exerciseModel.training.nameWorkout),
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
                  exerciseModel.addExercise(context);
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
                  final item = exerciseModel.data.removeAt(oldIndex);
                  exerciseModel.data.insert(newIndex, item);
                  for (int i = 0; i < exerciseModel.data.length; i++) {
                    exerciseModel.data[i].ordering = i.toString();
                  }
                });

                exerciseModel.fetchSetExercise();
              },
              children: exerciseModel.data
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
                                onPressed: () => exerciseModel.removeItem(
                                  index,
                                  context,
                                ),
                              ),
                              const Icon(Icons.menu),
                            ],
                          ),
                          onTap: () {
                            if (item.id != "0") {
                              exerciseModel.itemExercise = item;
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
