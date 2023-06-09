import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../functions/get_functions.dart';
import '../../../models/coach.dart';
import '../../details/details_screen.dart';

class ClientMan extends StatefulWidget {
  const ClientMan({
    super.key,
  });

  @override
  State<ClientMan> createState() => _ClientMan();
}

class _ClientMan extends State<ClientMan> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < listOfClients.length; i++)
            Container(
              margin: const EdgeInsets.only(
                left: 20,
                top: 20,
                bottom: 20,
              ),
              child: Column(children: <Widget>[
                Container(
                  child: Container(
                    height: 100,
                    width: 200,
                    padding: const EdgeInsets.all(kDefaultPadding / 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                                  text: "${listOfClients[i].name}\n"
                                      .toUpperCase(),
                                  style: const TextStyle(color: kTextColor),
                                ),
                                TextSpan(
                                  text: "${listOfClients[i].cardnumber}\n"
                                      .toUpperCase(),
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
                          "${listOfClients[i].age}\n",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: kPrimaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            )
        ],
      ),
    );
  }
}
