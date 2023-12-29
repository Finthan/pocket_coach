import 'package:pocket_coach/screens/app/main_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:flutter/services.dart';

import 'components/auth_natification.dart';
import 'constants.dart';
import 'screens/auth_registration/auth_registration_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
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
              Theme.of(context).textTheme.apply(bodyColor: kTextFieldColor),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            backgroundColor: kPrimaryColor,
            titleTextStyle: TextStyle(
              color: kWhiteColor,
              fontSize: 24,
            ),
            elevation: 4, // Отключите встроенную тень
            shadowColor: Colors.black,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true, // Заполненный фон
            fillColor: kWhiteColor, // Цвет фона
            contentPadding: const EdgeInsets.symmetric(
                vertical: 14, horizontal: 16), // Отступы внутри поля
            hintStyle: const TextStyle(color: kIconMessage), // Стиль подсказки
            labelStyle: const TextStyle(color: Colors.black), // Стиль метки
            errorStyle: const TextStyle(color: Colors.red), // Стиль ошибки
            // Другие настройки, которые вы хотите применить к TextField
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: kPrimaryColor),
              borderRadius: BorderRadius.circular(10),
              // Цвет выделения рамки при фокусе
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: kTextColor),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: kPrimaryColor, // Цвет введенного текста
            selectionColor: kPrimaryColor, // Цвет выделенного текста
            selectionHandleColor: kPrimaryColor, // Цвет ручек выделения текста
            // Другие настройки, которые вы хотите применить к выделению текста
          ),
        ),
        home: _isAuth ? const MainApp() : const AuthRegistrationScreen(),
      ),
    );
  }
}
