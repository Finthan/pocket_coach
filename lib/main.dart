import 'package:pocket_coach/screens/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

import 'constants.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        SfGlobalLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru'),
      ],
      locale: const Locale('ru'),
      debugShowCheckedModeBanner: false,
      title: 'Pocket coach',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: kPrimaryColor,
          onPrimary: kWhiteColor,
          secondary: Colors.white,
          onSecondary: Colors.white,
          error: Colors.white,
          onError: Colors.white,
          background: Colors.white,
          onBackground: Colors.white,
          surface: Colors.white,
          onSurface: kWhiteColor,
        ),
        scaffoldBackgroundColor: kBackgroundColor,
        primaryColor: kNavBarIconColor,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: kPrimaryColor),
      ),
      home: const App(),
    );
  }
}
