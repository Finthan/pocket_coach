import 'package:flutter/material.dart';
import 'components/body.dart';

class TutorScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(
        title: title,
        status: status,
        number: number,
        price: price,
        image: image,
      ),
    );
  }
}
