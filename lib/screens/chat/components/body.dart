import 'package:flutter/material.dart';

import '../../../info.dart';
import 'chat_widget.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatWidget(users: users),
    );
  }
}
