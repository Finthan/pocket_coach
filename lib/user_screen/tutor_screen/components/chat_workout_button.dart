import 'package:flutter/material.dart';

import '../../../constants.dart';

class ChatWorkoutButton extends StatelessWidget {
  const ChatWorkoutButton({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: size.width / 2,
          height: 84,
          child: TextButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                  ),
                )),
                backgroundColor: MaterialStateProperty.all(kPrimaryColor)),
            onPressed: () {}, //=> _openTelegramChat()
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
  }
}
