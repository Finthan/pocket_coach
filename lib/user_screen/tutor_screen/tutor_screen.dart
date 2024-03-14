import 'package:flutter/material.dart';
import 'components/body.dart';

class TutorScreen extends StatefulWidget {
  const TutorScreen({
    super.key,
    required this.title,
    required this.image,
    required this.status,
    required this.price,
    required this.number,
  });

  final String image, title, status, price, number;

  @override
  State<TutorScreen> createState() => _TutorScreenState();
}

class _TutorScreenState extends State<TutorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(
        title: widget.title,
        status: widget.status,
        number: widget.number,
        price: widget.price,
        image: widget.image,
      ),
    );
  }
}
