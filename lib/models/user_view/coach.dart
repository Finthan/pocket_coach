import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../all_class.dart';
import '../../constants.dart';

class Coach extends StatefulWidget {
  const Coach({
    super.key,
    required this.index,
    required this.length,
    required this.press,
  });

  final int index;
  final int length;
  final void Function() press;

  @override
  State<Coach> createState() => _CoachState();
}

class _CoachState extends State<Coach> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UsersModel>(
      builder: (context, usersModel, child) {
        return GestureDetector(
          onTap: widget.press,
          child: Container(
            margin: EdgeInsets.only(
              left: 20,
              top: 20,
              bottom: 20,
              right: (widget.index == widget.length - 1) ? 20 : 0,
            ),
            child: Column(children: <Widget>[
              Container(
                height: 100,
                width: 200,
                padding: const EdgeInsets.all(kDefaultPadding / 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                                  "${usersModel.listOfTutors[widget.index].name}\n"
                                      .toUpperCase(),
                              style: const TextStyle(
                                  color:
                                      kTextColor), //Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextSpan(
                              text: usersModel
                                  .listOfTutors[widget.index].typeOfTraining!
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
                      '₽${int.parse(usersModel.listOfTutors[widget.index].cost!)}',
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
        );
      },
    );
  }
}
