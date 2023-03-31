import 'package:flutter/material.dart';

import '../../../constants.dart';

class IconMessage extends StatelessWidget {
  const IconMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 15,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: kIconMessage,
          child: const Icon(
            Icons.person_outline,
            color: kPrimaryColor,
            size: 40.0,
          ),
        ),
      ),
    );
  }
}
