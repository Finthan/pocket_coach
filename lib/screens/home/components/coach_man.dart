import 'package:flutter/material.dart';

import '../../../functions/get_functions.dart';
import '../../../models/coach.dart';
import '../../details/details_screen.dart';

class CoachMan extends StatefulWidget {
  const CoachMan({
    super.key,
  });

  @override
  State<CoachMan> createState() => _CoachMan();
}

class _CoachMan extends State<CoachMan> {
  @override
  Widget build(BuildContext context) {
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
                    builder: (context) => DetailsScreen(
                      title: listOfTutors[i].name,
                      country: listOfTutors[i].typeOfTraining,
                      image: "assets/images/men_${i + 1}.jpg",
                      price: int.parse(listOfTutors[i].cost),
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
}
