import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../all_class.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (var i = 0;
                i < context.watch<MeModel>().listOfTutors!.length;
                i++)
              Coach(
                image: "assets/images/men_${i + 1}.jpg",
                title: context.watch<MeModel>().listOfTutors![i].name,
                typeOfTraning:
                    context.watch<MeModel>().listOfTutors![i].typeOfTraining!,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TutorScreen(
                        title: context.watch<MeModel>().listOfTutors![i].name,
                        status: context
                            .watch<MeModel>()
                            .listOfTutors![i]
                            .typeOfTraining!,
                        number:
                            context.watch<MeModel>().listOfTutors![i].number,
                        image: "assets/images/men_${i + 1}.jpg",
                        price: context.watch<MeModel>().listOfTutors![i].cost!,
                      ),
                    ),
                  );
                },
                price:
                    int.parse(context.watch<MeModel>().listOfTutors![i].cost!),
              ),
          ],
        ),
      ),
    );
  }
}
