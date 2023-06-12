import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../all_class.dart';
import '../../main.dart';
import '../../user_screen/tutor_screen/tutor_screen.dart';
import 'coach.dart';

class CoachMan extends StatefulWidget {
  const CoachMan({
    super.key,
  });

  @override
  State<CoachMan> createState() => _CoachMan();
}

class _CoachMan extends State<CoachMan> {
  @override
  void initState() {
    super.initState();
    getTutors();
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
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'get',
      'object': 'tutors',
    });
    try {
      getTutorsList = await http.get(uri);
    } catch (e) {
      print(e);
    }
    String jsonString = "";
    if (getTutorsList.statusCode == 200 && isAuth == true) {
      var decodedResponse =
          jsonDecode(utf8.decode(getTutorsList.bodyBytes)) as Map;
      jsonString = jsonEncode(decodedResponse['data']);
    }

    try {
      final json = await jsonDecode(jsonString) as List<dynamic>;
      if (json.length > 0) {
        listOfTutors = json
            .map((dynamic e) => Tutors.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getTutors(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var i = 0; i < listOfTutors.length; i++)
                    Coach(
                      image: "assets/images/men_${i + 1}.jpg",
                      title: listOfTutors[i].name,
                      TypeOfTraning: listOfTutors[i].typeOfTraining,
                      press: () {},
                      price: int.parse(listOfTutors[i].cost),
                    ),
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
        });
  }
}
