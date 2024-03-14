import 'dart:convert';

import 'package:pocket_coach/all_class.dart';
import 'package:pocket_coach/screens/app/main_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'components/auth_natification.dart';
import 'constants.dart';
import 'info.dart';
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
    _initAuth();
  }

  Future<void> _initAuth() async {
    bool auth = await _getAuth();
    print("isAuth $auth");
    setState(() {
      _isAuth = auth;
      Main.isAuth = auth;
    });
  }

  Future<bool> _getAuth() async {
    var prefs = await SharedPreferences.getInstance();
    print("prefs.getBool('auth') ${prefs.getBool('auth')}");
    if (prefs.getBool('auth') == true) {
      _initMe();
      _initClient();
    }
    return prefs.getBool('auth') ?? false;
  }

  Future<void> _initMe() async {
    String stringMe = await _getMe();
    print("stringMe $stringMe");
    setState(() {
      me = Me(id: stringMe);
    });
  }

  Future<String> _getMe() async {
    var prefs = await SharedPreferences.getInstance();
    print("prefs.getString('me') ${prefs.getString('me')}");
    return prefs.getString('me') ?? "-0";
  }

  Future<void> _initClient() async {
    bool client = await _getClient();
    print("client $client");
    setState(() {
      isClient = client;
    });
  }

  Future<bool> _getClient() async {
    var prefs = await SharedPreferences.getInstance();
    print("prefs.getBool('client') ${prefs.getBool('client')}");
    _auth(); 
    return prefs.getBool('client') ?? false;
  }

  Future<void> _auth() async {
    var prefs = await SharedPreferences.getInstance();
    bool? client = prefs.getBool('client');
    if (client!) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? clientJson = prefs.getString('clientMe');
      setState(() {
        clientMe = Client.fromJson(jsonDecode(clientJson!));
      });
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? tutorJson = prefs.getString('tutorMe');
      print("prefs.getString('tutorMe') ${prefs.getString('tutorMe')}");
      print("prefs.getString('clientMe') ${prefs.getString('clientMe')}");
      setState(() {
        tutorMe = Tutor.fromJson(jsonDecode(tutorJson!));
      });
    }
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
