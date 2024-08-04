import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../all_class.dart';
import '../../../constants.dart';
import '../../../screens/workout/components/create_workout.dart';

class ChatWorkoutButton extends StatelessWidget {
  const ChatWorkoutButton({
    super.key,
    required this.size,
  });

  final Size size;

  void openUrl(String number) async {
    var url = Uri.parse('https://t.me/$number');
    await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UsersModel>(
      builder: (context, usersModel, child) {
        int index = usersModel.indexAllClients;
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
                onPressed: () {
                  openUrl(usersModel.listOfAllClients[index].number);
                },
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
                      builder: (context) => const CreateWorkout(),
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
      },
    );
  }
}
