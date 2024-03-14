import 'package:flutter/material.dart';
import 'components/body.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({
    super.key,
    required this.title,
    required this.image,
    required this.status,
    required this.age,
    required this.id,
    required this.number,
  });

  final String image, title, status, age, id, number;

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(
        id: widget.id,
        title: widget.title,
        status: widget.status,
        age: widget.age,
        number: widget.number,
        image: widget.image,
      ),
    );
  }
}
