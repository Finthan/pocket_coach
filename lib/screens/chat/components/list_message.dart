import 'package:flutter/material.dart';
import 'package:pocket_coach/screens/chat/components/sender_message_card.dart';

import '../../../all_class.dart';
import 'my_message_card.dart';

class ListMessage extends StatelessWidget {
  const ListMessage({super.key, required this.messages});

  final List<Message> messages;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (var j = 0; j < messages.length; j++)
          messages[j].isMe
              ? MyMessageCard(
                  message: messages[j].message,
                  date: messages[j].time,
                )
              : SenderMessageCard(
                  message: messages[j].message,
                  date: messages[j].time,
                ),
      ],
    );
  }
}
