import 'package:flutter/material.dart';

import '../../../constants.dart';

class TitleSideScreens extends StatelessWidget {
  const TitleSideScreens({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(-5, 0),
            blurRadius: 50,
            color: kButtonBackSideSrceens.withOpacity(0.8),
          ),
        ],
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 25,
        ),
      ),
    );
  }
}
