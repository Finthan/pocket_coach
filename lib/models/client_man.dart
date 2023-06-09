import 'package:flutter/material.dart';
import 'package:pocket_coach/all_class.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../../constants.dart';
import '../functions/get_functions.dart';
import '../main.dart';
import '../screens/workout/workout_screen.dart';

class ClientMan extends StatefulWidget {
  const ClientMan({
    super.key,
  });

  @override
  State<ClientMan> createState() => _ClientMan();
}

class _ClientMan extends State<ClientMan> {
  void initState() {
    super.initState();
    getClients();
  }

  List<Clients> listOfClients = [
    Clients(
      id: '',
      name: '',
      age: '',
      gender: '',
      cardnumber: '',
    ),
  ];

  Future<void> getClients() async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'get',
      'object': 'clients',
    });
    getTutorsList = await http.get(uri);
    String jsonString = "";
    if (getTutorsList.statusCode == 200 && isAuth == true) {
      print("isAuth");
      setState(() {
        var decodedResponse =
            jsonDecode(utf8.decode(getTutorsList.bodyBytes)) as Map;
        jsonString = jsonEncode(decodedResponse['data']);
      });
    }

    try {
      print(jsonString);
      final json = await jsonDecode(jsonString) as List<dynamic>;
      listOfClients = json
          .map((dynamic e) => Clients.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getClients(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var i = 0; i < listOfClients.length; i++)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WorkoutScreen(),
                          ),
                        );
                      },
                      child: Container(
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
                              padding:
                                  const EdgeInsets.all(kDefaultPadding / 2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
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
                                            style: const TextStyle(
                                                color: kTextColor),
                                          ),
                                          TextSpan(
                                            text:
                                                "${listOfClients[i].cardnumber}\n"
                                                    .toUpperCase(),
                                            style: TextStyle(
                                              color: kPrimaryColor
                                                  .withOpacity(0.5),
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
                      ),
                    )
                ],
              ),
            );
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var i = 0; i < listOfClients.length; i++)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WorkoutScreen(),
                          ),
                        );
                      },
                      child: Container(
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
                              padding:
                                  const EdgeInsets.all(kDefaultPadding / 2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
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
                                            style: const TextStyle(
                                                color: kTextColor),
                                          ),
                                          TextSpan(
                                            text:
                                                "${listOfClients[i].cardnumber}\n"
                                                    .toUpperCase(),
                                            style: TextStyle(
                                              color: kPrimaryColor
                                                  .withOpacity(0.5),
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
                      ),
                    )
                ],
              ),
            );
          }
        });
  }
}
