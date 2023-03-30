import 'package:flutter/material.dart';

import '../../../../constants.dart';

class ButtonSettings extends StatelessWidget {
  const ButtonSettings({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: TextButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
            padding: MaterialStateProperty.all(
                const EdgeInsets.only(left: 15, top: 15, bottom: 15)),
            backgroundColor: MaterialStateProperty.all(kPrimaryColor)),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(text,
              style: const TextStyle(color: kTextSideScreens, fontSize: 15),
              textAlign: TextAlign.left),
        ),
        onPressed: () {
          //сделать всплывающие окна в которых вводятся новые данные
        },
      ),
    );
  }
}
