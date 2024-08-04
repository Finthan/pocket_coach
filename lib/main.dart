import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'all_class.dart';
import 'constants.dart';
import 'screens/main_app/main_app.dart';
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
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MeModel()),
        ChangeNotifierProxyProvider<MeModel, UsersModel>(
          create: (_) => UsersModel(),
          update: (context, meModel, usersModel) =>
              usersModel!..updateWithMeModel(meModel),
        ),
        ChangeNotifierProxyProvider<UsersModel, TrainingModel>(
          create: (_) => TrainingModel(),
          update: (context, usersModel, trainingModel) =>
              trainingModel!..updateWithUsersModel(usersModel),
        ),
        ChangeNotifierProxyProvider<TrainingModel, ExerciseModel>(
          create: (_) => ExerciseModel(),
          update: (context, trainingModel, exerciseModel) =>
              exerciseModel!..updateWithTrainingModel(trainingModel),
        ),
        ChangeNotifierProxyProvider<ExerciseModel, ApproachesModel>(
          create: (_) => ApproachesModel(),
          update: (context, exerciseModel, approachesModel) =>
              approachesModel!..updateWithExerciseModel(exerciseModel),
        ),
      ],
      child: Consumer<MeModel>(
        builder: (context, meModel, child) {
          if (!meModel.isAuth) meModel.getAuth();
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
                elevation: 4,
                shadowColor: Colors.black,
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: kWhiteColor,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                hintStyle: const TextStyle(color: kIconMessage),
                labelStyle: const TextStyle(color: Colors.black),
                errorStyle: const TextStyle(color: Colors.red),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: kPrimaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: kTextColor),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              textSelectionTheme: const TextSelectionThemeData(
                cursorColor: kPrimaryColor,
                selectionColor: kPrimaryColor,
                selectionHandleColor: kPrimaryColor,
              ),
            ),
            home: meModel.isLoad
                ? meModel.isAuth
                    ? const MainApp()
                    : const AuthRegistrationScreen()
                : meModel.isAuth
                    ? Container()
                    : const AuthRegistrationScreen(),
          );
        },
      ),
    );
  }
}
