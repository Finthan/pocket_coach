import 'package:flutter/material.dart';

import '../constants.dart';

class AnimatedGradientExample extends StatelessWidget {
  const AnimatedGradientExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnimatedGradientContainer(
      width: 200,
      height: 100,
      colors: [
        kTextChat,
        kWhiteColor,
      ],
      duration: Duration(seconds: 3),
    );
  }
}

class AnimatedGradientContainer extends StatefulWidget {
  final double width;
  final double height;
  final List<Color> colors;
  final Duration duration;

  const AnimatedGradientContainer(
      {super.key,
      required this.width,
      required this.height,
      required this.colors,
      required this.duration});

  @override
  State<AnimatedGradientContainer> createState() =>
      _AnimatedGradientContainerState();
}

class _AnimatedGradientContainerState extends State<AnimatedGradientContainer>
    with SingleTickerProviderStateMixin {
  late int _colorIndex;
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _colorIndex = 0;
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0, end: widget.colors.length.toDouble())
        .animate(_controller)
      ..addListener(() {
        setState(() {
          _colorIndex = _animation.value.toInt();
        });
      });
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: widget.width,
      height: widget.height,
      duration: widget.duration,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        gradient: LinearGradient(
          colors: [
            widget.colors[_colorIndex % widget.colors.length],
            widget.colors[(_colorIndex + 1) % widget.colors.length],
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}
