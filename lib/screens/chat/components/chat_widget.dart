import 'package:flutter/material.dart';

import '../../../all_class.dart';
import '../../../constants.dart';
import 'chat.dart';
import 'list_chats.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({
    super.key,
    required this.users,
  });

  final List<User> users;

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          stretch: true,
          forceElevated: true,
          pinned: true,
          floating: false,
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
              for (var i = 0; i < widget.users.length; i++)
                GestureDetector(
                  child: ListChats(users: widget.users, i: i),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Chat(users: widget.users, i: i),
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
