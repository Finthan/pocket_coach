import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../all_class.dart';
import '../../components/animated_gradient_exmple.dart';
import '../../screens/workout/workout_screen.dart';
import '../../../constants.dart';

class MyClientMan extends StatefulWidget {
  const MyClientMan({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  State<MyClientMan> createState() => _MyClientManState();
}

class _MyClientManState extends State<MyClientMan> {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0;
                i < Provider.of<MeModel>(context).listOfMyClients!.length;
                i++)
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
                  margin: EdgeInsets.only(
                    left: 20,
                    top: 20,
                    bottom: 20,
                    right: (i ==
                            Provider.of<MeModel>(context)
                                    .listOfMyClients!
                                    .length -
                                1)
                        ? 20
                        : 0,
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
                                    text:
                                        "${Provider.of<MeModel>(context).listOfMyClients![i].name}\n"
                                            .toUpperCase(),
                                    style: const TextStyle(color: kTextColor),
                                  ),
                                  TextSpan(
                                    text:
                                        "${Provider.of<MeModel>(context).listOfMyClients![i].cardnumber}\n"
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
                            context.watch<MeModel>().listOfMyClients![i].age,
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
      ),
    );
  }
}
