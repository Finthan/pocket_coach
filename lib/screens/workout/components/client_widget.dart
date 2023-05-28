import 'package:flutter/material.dart';

import '../../../constants.dart';

class ClientWidget extends StatelessWidget {
  const ClientWidget({
    super.key,
    required this.title,
    required this.age,
    required this.cardnumber,
    required this.gender,
    required this.press,
  });

  final String title, age, cardnumber, gender;
  final void Function() press;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 20,
        top: 20,
        bottom: 20,
      ),
      child: Column(
        children: <Widget>[
          Container(
            child: Container(
              height: 100,
              width: 200,
              padding: const EdgeInsets.all(kDefaultPadding / 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 10),
                    blurRadius: 50,
                    color: kPrimaryColor.withOpacity(0.23),
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 140,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "$title\n".toUpperCase(),
                            style: const TextStyle(color: kTextColor),
                          ),
                          TextSpan(
                            text: cardnumber.toUpperCase(),
                            style: TextStyle(
                              color: kPrimaryColor.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$age',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: kPrimaryColor),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
              onTap: press,
              child: Container(
                height: 50,
                width: 200,
                padding: const EdgeInsets.all(kDefaultPadding / 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 10),
                      blurRadius: 50,
                      color: kPrimaryColor.withOpacity(0.23),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text("Выбрать пользователя"),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
