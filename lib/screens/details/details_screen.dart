import 'package:flutter/material.dart';
import 'components/body.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    super.key,
    required this.image,
    required this.title,
    required this.country,
    required this.price,
  });

  final String image, title, country;
  final int price;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(
        title: widget.title,
        country: widget.country,
        price: widget.price,
        image: widget.image,
      ),
    );
  }
}
