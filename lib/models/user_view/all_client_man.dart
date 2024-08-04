import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../all_class.dart';
import '../../../constants.dart';
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
    return Consumer<UsersModel>(
      builder: (context, usersModel, child) {
        var length = usersModel.listOfAllClients.length;
        return SizedBox(
          width: widget.size.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < length; i++)
                  GestureDetector(
                    onTap: () {
                      usersModel.indexAllClients = i;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ClientScreen(),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        left: 20,
                        top: 20,
                        bottom: 20,
                        right: (i == usersModel.listOfMyClients.length - 1)
                            ? 20
                            : 0,
                      ),
                      child: Column(
                        children: <Widget>[
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
                                              "${usersModel.listOfMyClients[i].name}\n"
                                                  .toUpperCase(),
                                          style: const TextStyle(
                                              color: kTextColor),
                                        ),
                                        TextSpan(
                                          text:
                                              "${usersModel.listOfMyClients[i].cardnumber}\n"
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
                                  usersModel.listOfMyClients[i].age,
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
          ),
        );
      },
    );
  }
}
