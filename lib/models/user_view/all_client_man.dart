import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../all_class.dart';
import '../../components/animated_gradient_exmple.dart';
import '../../info.dart';
import '../../../constants.dart';
import '../../main.dart';
import '../../user_screen/client_screen/client_screen.dart';

class AllClientMan extends StatefulWidget {
  const AllClientMan({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  State<AllClientMan> createState() => _AllClientMan();
}

class _AllClientMan extends State<AllClientMan> {
  late Timer _timer;
  bool _isAuth = true;

  @override
  void initState() {
    super.initState();
    _isAuth = Main.isAuth;
    getAllClients();
    _timer = Timer.periodic(
        const Duration(seconds: 5), (Timer t) => getAllClients());
  }

  @override
  void dispose() {
    _isAuth = false;
    _timer.cancel();
    listOfClients = [
      Clients(
        id: '',
        name: '',
        age: '',
        number: '',
        gender: '',
        cardnumber: '',
      ),
    ];
    super.dispose();
  }

  List<Clients> listOfClients = [];

  Future<List<Clients>> getAllClients() async {
    if (_isAuth) {
      Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
        'apiv': '1',
        'action': 'get',
        'object': 'allclients',
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
        future: getAllClients(),
        builder: (BuildContext context, AsyncSnapshot<List<Clients>> snapshot) {
          if (!snapshot.hasData) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < 5; i++)
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
                            builder: (context) => ClientScreen(
                              id: listOfClients[i].id,
                              title: listOfClients[i].name,
                              age: listOfClients[i].age,
                              number: listOfClients[i].number,
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
                        child: Column(
                          children: <Widget>[
                            Container(
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
                          ],
                        ),
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
