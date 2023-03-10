import 'package:flutter/material.dart';

import 'constants.dart';
import 'screens/home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plant App',
      theme: ThemeData(
        scaffoldBackgroundColor: kBackgroundColor,
        primaryColor: kNavBarIconColor,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: kPrimaryColor),
      ),
      home: const HomeScreen(),
    );
  }
}
