import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../screens/workout/components/create_workout.dart';

class ChatWorkoutButton extends StatelessWidget {
  const ChatWorkoutButton({
    super.key,
    required this.size,
    required this.id,
  });

  final Size size;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: size.width / 2,
          height: 84,
          child: TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                  ),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(kPrimaryColor),
            ),
            onPressed: () {}, //TODO
            child: const Text(
              "Перейти в чат",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
        SizedBox(
          width: size.width / 2,
          height: 84,
          child: TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                  ),
                ),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateWorkout(
                    id: id,
                  ),
                ),
              );
            },
            child: const Text(
              "Создать тренировку",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
