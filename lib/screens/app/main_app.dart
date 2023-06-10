import 'package:flutter/material.dart';
import 'package:pocket_coach/screens/app/client_app.dart';
import 'package:pocket_coach/screens/app/tutor_app.dart';
import 'package:pocket_coach/screens/auth_registration.dart/auth_registration_screen.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isClient ? const ClientApp() : const TutorApp(),
    );
  }
}
