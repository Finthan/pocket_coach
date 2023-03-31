import 'package:flutter/material.dart';

import '../../../constants.dart';

class TitleMessage extends StatelessWidget {
  const TitleMessage({
    super.key,
    required this.users,
    required this.i,
  });

  final List<User> users;
  final int i;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 8,
        right: 10,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: size.width - 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  users[i].username,
                  style: const TextStyle(color: kTextSideScreens),
                ),
                Text(
                  users[i].time,
                  style: const TextStyle(color: kTextSideScreens),
                ),
              ],
            ),
          ),
          SizedBox(
            width: size.width - 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check,
                  color: kCheckMessage,
                  //TODO Изменять иконку если пользователь в сети на двойные галочки
                  //TODO И изменять цвет если пользователь зашел в чат
                  //TODO В чате сделать идентификатор захождения в чат во время нажатия на виджет чата
                  size: 20.0,
                ),
                SizedBox(
                  width: size.width - 200,
                  child: Text(
                    users[i].lastMessage,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: kTextSideScreens),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
