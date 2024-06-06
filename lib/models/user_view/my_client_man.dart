import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../all_class.dart';
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
    return Consumer<MeModel>(
      builder: (context, meModel, child) {
        var length = meModel.listOfMyClients != null
            ? meModel.listOfMyClients!.length
            : 0;
        return SizedBox(
          width: widget.size.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < length; i++)
                  ClientManWidget(
                    index: i,
                    length: length,
                    press: () {
                      meModel.index = i;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WorkoutScreen(),
                        ),
                      );
                    },
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}

class ClientManWidget extends StatefulWidget {
  const ClientManWidget({
    super.key,
    required this.index,
    required this.length,
    required this.press,
  });

  final int index;
  final int length;
  final void Function() press;

  @override
  State<ClientManWidget> createState() => _ClientManWidgetState();
}

class _ClientManWidgetState extends State<ClientManWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MeModel>(
      builder: (context, meModel, child) {
        return GestureDetector(
          onTap: widget.press,
          child: Container(
            margin: EdgeInsets.only(
              left: 20,
              top: 20,
              bottom: 20,
              right: (widget.index == widget.length - 1) ? 20 : 0,
            ),
            child: Column(
              children: <Widget>[
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
                                    "${meModel.listOfMyClients![widget.index].name}\n"
                                        .toUpperCase(),
                                style: const TextStyle(color: kTextColor),
                              ),
                              TextSpan(
                                text:
                                    "${meModel.listOfMyClients![widget.index].cardnumber}\n"
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
                        meModel.listOfMyClients![widget.index].age,
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
        );
      },
    );
  }
}
