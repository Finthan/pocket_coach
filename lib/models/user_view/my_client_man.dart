import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../all_class.dart';
import '../../components/animated_gradient_exmple.dart';
import '../../info.dart';
import '../../main.dart';
import '../../screens/workout/workout_screen.dart';
import '../../../constants.dart';

class MyClientMan extends StatefulWidget {
  const MyClientMan({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  State<MyClientMan> createState() => _MyClientMan();
}

class _MyClientMan extends State<MyClientMan> {
  bool _isAuth = false;

  @override
  void initState() {
    super.initState();
    _isAuth = Main.isAuth;
    getMyClients();
    Timer.periodic(const Duration(seconds: 5), (Timer t) => getMyClients());
  }

  @override
  void dispose() {
    super.dispose();
    _isAuth = false;
    me = Me(id: "-0");
  }

  List<Clients> listOfClients = [];

  Future<List<Clients>> getMyClients() async {
    if (_isAuth) {
      Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
        'apiv': '1',
        'action': 'get',
        'object': 'myclients',
        'id_user': me.id.toString(),
      });

      var connectivityResult = await (Connectivity().checkConnectivity());

      if (connectivityResult != ConnectivityResult.none) {
        myClientsList = await http.get(uri);

        String jsonString = "";
        if (myClientsList.statusCode == 200 && _isAuth == true) {
          var decodedResponse =
              jsonDecode(utf8.decode(myClientsList.bodyBytes)) as Map;
          jsonString = jsonEncode(decodedResponse['data']);
        }

        try {
          final json = await jsonDecode(jsonString) as List<dynamic>;
          if (json.isNotEmpty) {
            setState(() {
              listOfClients = json
                  .map((dynamic e) =>
                      Clients.fromJson(e as Map<String, dynamic>))
                  .toList();
            });
          }
        } catch (error) {}
      }
    }
    return listOfClients;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width,
      child: FutureBuilder(
        future: getMyClients(),
        builder: (BuildContext context, AsyncSnapshot<List<Clients>> snapshot) {
          if (!snapshot.hasData) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: Row(
                children: [
                  for (var i = 0; i < 1; i++)
                    Container(
                      margin: EdgeInsets.only(
                        left: 20,
                        top: 20,
                        bottom: 20,
                        right: (i == 4) ? 20 : 0,
                      ),
                      child: const AnimatedGradientExample(),
                    )
                ],
              ),
            );
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                              number: listOfClients[i].number,
                              age: listOfClients[i].age,
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
        },
      ),
    );
  }
}
