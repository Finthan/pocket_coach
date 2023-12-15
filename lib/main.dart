import 'package:pocket_coach/screens/app/main_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

import 'components/auth_natification.dart';
import 'constants.dart';
import 'screens/auth_registration.dart/auth_registration_screen.dart';

void main() {
  runApp(const Main());
}

class Main extends StatefulWidget {
  static bool isAuth = false;

  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  bool _isAuth = false;

  @override
  void initState() {
    super.initState();
    _isAuth = Main.isAuth;
  }

  @override
  void didUpdateWidget(Main oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _isAuth = Main.isAuth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<AuthNotification>(
      onNotification: (notification) {
        setState(() {
          _isAuth = notification.isAuth;
        });
        return true;
      },
      child: MaterialApp(
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
          scaffoldBackgroundColor: kBackgroundColor,
          primaryColor: kNavBarIconColor,
          textTheme:
              Theme.of(context).textTheme.apply(bodyColor: kPrimaryColor),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            backgroundColor: kPrimaryColor,
            titleTextStyle: TextStyle(
              color: kWhiteColor,
              fontSize: 24,
            ),
          ),
        ),
        home: _isAuth ? const MainApp() : const AuthRegistrationScreen(),
      ),
    );
  }
}
