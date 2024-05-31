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
    return Consumer<MeModel>(
      builder: (contextModel, meModel, child) {
        return SizedBox(
          width: widget.size.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                if (meModel.listOfTutors != null)
                  for (var i = 0; i < meModel.listOfTutors!.length; i++)
                    Coach(
                      index: i,
                      length: meModel.listOfTutors!.length,
                      press: () {
                        meModel.indexCoachMan = i;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TutorScreen(),
                          ),
                        );
                      },
                    ),
              ],
            ),
          ),
        );
      },
    );
  }
}
