import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../all_class.dart';
import '../../../constants.dart';

class ChatWorkoutButton extends StatelessWidget {
  const ChatWorkoutButton({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Consumer<UsersModel>(
      builder: (context, usersModel, child) {
        return Row(
          children: <Widget>[
            SizedBox(
              width: size.width / 2,
              height: 84,
              child: TextButton(
                style: ButtonStyle(
                    shape:
                        MaterialStateProperty.all(const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                      ),
                    )),
                    backgroundColor: MaterialStateProperty.all(kPrimaryColor)),
                onPressed: () {
                  var url =
                      'https://t.me/${usersModel.listOfTutors[usersModel.indexCoachMan].number}';
                  launch(url);
                }, //=> _openTelegramChat()
                child: const Text(
                  "Перейти в чат",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Expanded(child: Container()),
          ],
        );
      },
    );
  }
}
