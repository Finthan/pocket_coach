import 'package:flutter/material.dart';

import '../../../constants.dart';

class AnimatedBar extends StatefulWidget {
  const AnimatedBar({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  State<AnimatedBar> createState() => _AnimatedBarState();
}

class _AnimatedBarState extends State<AnimatedBar> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      margin: const EdgeInsets.only(
        bottom: 2,
      ),
      height: 4,
      width: widget.isActive ? 20 : 0,
      decoration: const BoxDecoration(
        color: kNavBarIconColor,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
    );
  }
}
