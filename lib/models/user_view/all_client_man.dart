import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../all_class.dart';
import '../../info.dart';
import '../../../constants.dart';
import '../../main.dart';
import '../../user_screen/client_screen/client_screen.dart';

class AllClientMan extends StatefulWidget {
  const AllClientMan({
    super.key,
  });

  @override
  State<AllClientMan> createState() => _AllClientMan();
}

class _AllClientMan extends State<AllClientMan> {
  late Timer _timer;
  bool _isAuth = true;

  void initState() {
    super.initState();
    _isAuth = Main.isAuth;
    getAllClients();
    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) => getAllClients());
  }

  void dispose() {
    _timer.cancel();
    super.dispose();
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

  Future<void> getAllClients() async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'get',
      'object': 'allclients',
      'id_user': me[0].id.toString(),
    });
    try {
      myClientsList = await http.get(uri);
    } catch (error) {
      print(
          'models.all_client_man:GETALLCLIENTS: получение данных по http: $error');
    }
    String jsonString = "";
    if (myClientsList.statusCode == 200 && _isAuth == true) {
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
    } catch (error) {
      print('models.all_client_man:GETALLCLIENTS: форматирование json: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getAllClients(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var i = 0; i < 3; i++)
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
                            builder: (context) => ClientScreen(
                              id: listOfClients[i].id,
                              title: listOfClients[i].name,
                              age: listOfClients[i].age,
                              status: listOfClients[i].cardnumber,
                              image: 'assets/images/men_0.jpg',
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 20,
                          top: 20,
                          bottom: 20,
                          right: (i == listOfClients.length - 1) ? 20 : 0,
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
                            // ),
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
