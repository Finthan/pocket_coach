import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.name,
    required this.status,
  });

  final String name, status;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: kTextColor,
        child: Icon(
          CupertinoIcons.person,
          color: kTextColorBackground,
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        status,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
