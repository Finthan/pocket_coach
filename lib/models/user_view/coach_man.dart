import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../all_class.dart';
import '../../components/animated_gradient_exmple.dart';
import '../../main.dart';
import '../../user_screen/tutor_screen/tutor_screen.dart';
import 'coach.dart';

class CoachMan extends StatefulWidget {
  const CoachMan({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  State<CoachMan> createState() => _CoachMan();
}

class _CoachMan extends State<CoachMan> {
  bool _isAuth = true;

  @override
  void initState() {
    _isAuth = Main.isAuth;
    super.initState();
    getTutors();
  }

  @override
  void dispose() {
    super.dispose();
    _isAuth = false;
  }

  List<Tutors> listOfTutors = [
    Tutors(
      id: '',
      name: '',
      age: '',
      gender: '',
      typeOfTraining: '',
      cost: '0',
    ),
  ];

  Future<void> getTutors() async {
    if (_isAuth) {
      Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
        'apiv': '1',
        'action': 'get',
        'object': 'tutors',
      });
      var connectivityResult = await (Connectivity().checkConnectivity());

      if (connectivityResult != ConnectivityResult.none) {
        getTutorsList = await http.get(uri);

        String jsonString = "";
        if (getTutorsList.statusCode == 200 && _isAuth == true) {
          var decodedResponse =
              jsonDecode(utf8.decode(getTutorsList.bodyBytes)) as Map;
          jsonString = jsonEncode(decodedResponse['data']);
        }

        try {
          final json = await jsonDecode(jsonString) as List<dynamic>;
          if (json.isNotEmpty) {
            listOfTutors = json
                .map((dynamic e) => Tutors.fromJson(e as Map<String, dynamic>))
                .toList();
          }
        } catch (error) {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width,
      child: FutureBuilder(
          future: getTutors(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var i = 0; i < 5; i++) const AnimatedGradientExample(),
                  ],
                ),
              );
            } else {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var i = 0; i < listOfTutors.length; i++)
                      Coach(
                        image: "assets/images/men_${i + 1}.jpg",
                        title: listOfTutors[i].name,
                        TypeOfTraning: listOfTutors[i].typeOfTraining,
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TutorScreen(
                                title: listOfTutors[i].name,
                                status: listOfTutors[i].typeOfTraining,
                                image: "assets/images/men_${i + 1}.jpg",
                                price: listOfTutors[i].cost,
                              ),
                            ),
                          );
                        },
                        price: int.parse(listOfTutors[i].cost),
                      ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
