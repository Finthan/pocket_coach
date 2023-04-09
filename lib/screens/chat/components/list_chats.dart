import 'package:flutter/material.dart';

import '../../../all_class.dart';
import '../../../constants.dart';

class ListChats extends StatelessWidget {
  const ListChats({
    super.key,
    required this.users,
    required this.i,
  });

  final List<User> users;
  final int i;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(top: 5, left: 10),
      leading: const CircleAvatar(
          radius: 25,
          backgroundImage: ExactAssetImage('assets/images/people.png')),
      title: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              users[i].username,
              style: const TextStyle(color: kTextSideScreens),
            ),
            Text(
              users[i].time,
              style: const TextStyle(color: kTextSideScreens),
            )
          ],
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              users[i].lastMessage,
              style: const TextStyle(color: kTextSideScreens),
            ),
            users[i].isRead
                ? Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: kPrimaryColor),
                        borderRadius: BorderRadius.circular(50),
                        color: kPrimaryColor),
                    child: Text(
                      users[i].unReadMessage,
                      style: const TextStyle(color: kTextSideScreens),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
