import 'package:flutter/material.dart';
import '../auth_registration.dart/auth_registration_screen.dart';
import 'components/body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    //print(tutorMe[0].id);
    return const Scaffold(
      body: Body(),
    );
  }
}
