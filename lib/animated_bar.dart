import 'package:flutter/material.dart';

import '../../../constants.dart';

class AnimatedBar extends StatelessWidget {
  const AnimatedBar({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      margin: const EdgeInsets.only(
        bottom: 2,
      ),
      height: 4,
      width: isActive ? 20 : 0,
      decoration: const BoxDecoration(
        color: kNavBarIconColor,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
    );
  }
}
