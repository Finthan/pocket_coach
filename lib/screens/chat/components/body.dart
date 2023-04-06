import 'package:flutter/material.dart';

import '../../../all_class.dart';
import '../../../constants.dart';
import '../../../info.dart';
import 'chat.dart';
import 'list_chats.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatWidget(users: users),
    );
  }
}

class ChatWidget extends StatelessWidget {
  const ChatWidget({
    super.key,
    required this.users,
  });

  final List<User> users;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          stretch: true,
          forceElevated: true,
          pinned: true,
          floating: false,
          backgroundColor: kPrimaryColor,
          toolbarHeight: 70,
          expandedHeight: 100,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              "Чаты",
              style: TextStyle(color: kTextColorBackground),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              for (var i = 0; i < users.length; i++)
                GestureDetector(
                  child: ListChats(users: users, i: i),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Chat(users: users, i: i),
                      ),
                    );
                  },
                ),
              Container(height: 20)
            ],
          ),
        ),
      ],
    );
  }
}
