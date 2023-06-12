import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../all_class.dart';
import '../../info.dart';
import '../../main.dart';
import '../../screens/workout/workout_screen.dart';
import '../../../constants.dart';

class MyClientMan extends StatefulWidget {
  const MyClientMan({
    super.key,
  });

  @override
  State<MyClientMan> createState() => _MyClientMan();
}

class _MyClientMan extends State<MyClientMan> {
  void initState() {
    super.initState();
    getMyClients();
    Timer.periodic(Duration(seconds: 5), (Timer t) => getMyClients());
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

  Future<void> getMyClients() async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'get',
      'object': 'myclients',
      'id_user': me[0].id.toString(),
    });
    try {
      myClientsList = await http.get(uri);
    } catch (error) {
      print('myClients $error');
    }
    String jsonString = "";
    if (myClientsList.statusCode == 200 && isAuth == true) {
      var decodedResponse =
          jsonDecode(utf8.decode(myClientsList.bodyBytes)) as Map;
      jsonString = jsonEncode(decodedResponse['data']);
    }

    try {
      final json = await jsonDecode(jsonString) as List<dynamic>;

      if (json.length > 0) {
        setState(() {
          listOfClients = json
              .map((dynamic e) => Clients.fromJson(e as Map<String, dynamic>))
              .toList();
        });
      }
      //print(json);
    } catch (error) {
      print('ошибка форматирования json myClients $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getMyClients(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var i = 0; i < 2; i++)
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: const EdgeInsets.only(
                        left: 20,
                        top: 20,
                        bottom: 20,
                      ),
                      child: Column(children: <Widget>[
                        Container(
                          height: 100,
                          width: 200,
                          padding: const EdgeInsets.all(kDefaultPadding / 2),
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
                                        style:
                                            const TextStyle(color: kTextColor),
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
                          builder: (context) => WorkoutScreen(
                            id: listOfClients[i].id,
                            name: listOfClients[i].name,
                            status: listOfClients[i].cardnumber,
                            age: listOfClients[i].age,
                          ),
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
                            padding: const EdgeInsets.all(kDefaultPadding / 2),
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
                                            color:
                                                kPrimaryColor.withOpacity(0.5),
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
      },
    );
  }
}
