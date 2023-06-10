import 'package:flutter/material.dart';
import 'components/body.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({
    super.key,
    required this.title,
    required this.image,
    required this.status,
    required this.price,
  });

  final String image, title, status;
  final int price;

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(
        title: widget.title,
        status: widget.status,
        price: widget.price,
        image: widget.image,
      ),
    );
  }
}
