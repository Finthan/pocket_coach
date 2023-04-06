import 'package:flutter/material.dart';

import '../../../all_class.dart';
import '../../../components/info_card.dart';
import '../../../constants.dart';
import '../../../info.dart';
import 'list_message.dart';

class Chat extends StatelessWidget {
  const Chat({
    super.key,
    required this.users,
    required this.i,
  });

  final List<User> users;
  final int i;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          splashRadius: 20,
          icon: const Icon(Icons.chevron_left),
          iconSize: 30,
          onPressed: () => Navigator.pop(context),
        ),
        title: InfoCard(
          name: users[i].username,
          status: users[i].status,
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListMessage(messages: messages),
          ),
          TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: kTextChat,
              prefixIcon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Icon(
                  Icons.emoji_emotions,
                  color: kPrimaryColor,
                ),
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Icon(
                      Icons.camera_alt,
                      color: kPrimaryColor,
                    ),
                    Icon(
                      Icons.attach_file,
                      color: kPrimaryColor,
                    ),
                  ],
                ),
              ),
              hintText: 'Type a message!',
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ],
      ),
    );
  }
}
