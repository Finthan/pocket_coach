import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../components/auth_natification.dart';
import '../../constants.dart';
import '../../info.dart';
import '../../main.dart';
import '../../all_class.dart';
import 'components/auth_text_field.dart';

class AuthRegistrationScreen extends StatefulWidget {
  const AuthRegistrationScreen({super.key});

  @override
  State<AuthRegistrationScreen> createState() => _AuthRegistrationScreenState();
}

Tutor tutorMe = Tutor(
  id: '',
  name: '',
  age: '',
  gender: '',
  typeOfTraining: '',
  cost: '',
);

Client clientMe = Client(
  id: '',
  name: '',
  age: '',
  gender: '',
  cardnumber: '',
);

var isClient = true;
var isRegClient = true;

class _AuthRegistrationScreenState extends State<AuthRegistrationScreen> {
  @override
  void initState() {
    super.initState();
    late bool _isAuth = Main.isAuth;
  }

  var isRegist = false;
  final _loginTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _nameTextController = TextEditingController();
  final _ageTextController = TextEditingController();
  final _genderTextController = TextEditingController();
  final _trainingTextController = TextEditingController();
  final _costTextController = TextEditingController();
  final _cardnumberTextController = TextEditingController();

  bool isLoginFocused = false;
  bool isPasswordFocused = false;
  bool isNameFocused = false;
  bool isAgeFocused = false;
  bool isGenderFocused = false;
  bool isCardnumberFocused = false;
  bool isCostFocused = false;
  bool isTrainingFocused = false;

  Future<void> _auth() async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'auth',
      'object': 'login',
      'login': _loginTextController.text,
      'pass': _passwordTextController.text,
    });

    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult != ConnectivityResult.none) {
      dynamic auth = await http.get(uri);
      var decodedResponse = jsonDecode(utf8.decode(auth.bodyBytes)) as Map;
      String jsonString = jsonEncode(decodedResponse['data']);

      try {
        final json = await jsonDecode(jsonString) as dynamic;

        Map<String, dynamic> jsonMap = json.first;
        String id = jsonMap['id'].toString();
        setState(() {
          me = Me(id: id);
        });

        Uri client = Uri.http('gymapp.amadeya.net', '/api.php', {
          'apiv': '1',
          'action': 'auth',
          'object': 'checkclient',
          'id': me.id.toString(),
        });

        Uri tutor = Uri.http('gymapp.amadeya.net', '/api.php', {
          'apiv': '1',
          'action': 'auth',
          'object': 'checktutor',
          'id': me.id.toString(),
        });

        dynamic checkClient = await http.get(client);
        var decodedClient =
            jsonDecode(utf8.decode(checkClient.bodyBytes)) as Map;
        checkClient = null;
        String? clientString = jsonEncode(decodedClient['data']);
        decodedClient.clear;

        dynamic checkTutor = await http.get(tutor);
        var decodedTutor = jsonDecode(utf8.decode(checkTutor.bodyBytes)) as Map;
        checkTutor = null;
        String? tutorString = jsonEncode(decodedTutor['data']);
        decodedTutor.clear;

        try {
          if (clientString.length > 2) {
            final jsonC = await jsonDecode(clientString) as dynamic;
            Map<String, dynamic> jsonMap = jsonC.first;
            String id = jsonMap['id'].toString();
            String name = jsonMap['name'].toString();
            String age = jsonMap['age'].toString();
            String gender = jsonMap['gender'].toString();
            String cardnumber = jsonMap['cardnumber'].toString();

            clientMe = Client(
              id: id,
              name: name,
              age: age,
              gender: gender,
              cardnumber: cardnumber,
            );
            isClient = true;
          } else if (tutorString.length > 2) {
            final jsonT = await jsonDecode(tutorString) as dynamic;

            Map<String, dynamic> jsonMap = jsonT.first;
            String id = jsonMap['id'].toString();
            String name = jsonMap['name'].toString();
            String age = jsonMap['age'].toString();
            String gender = jsonMap['gender'].toString();
            String typeOfTraining = jsonMap['type_of_training'].toString();
            String cost = jsonMap['cost'].toString();

            tutorMe = Tutor(
              id: id,
              name: name,
              age: age,
              gender: gender,
              typeOfTraining: typeOfTraining,
              cost: cost,
            );
            isClient = false;
          }
          tutorString = null;
          clientString = null;
        } catch (error) {}
      } catch (error) {}
      try {
        if (me.id != "-0") {
          setState(() {
            Main.isAuth = true;
            AuthNotification(true).dispatch(context);
          });
        } else {
          setState(() {
            Main.isAuth = false;
          });
        }
      } catch (error) {}
    }
  }

  Future<void> _regist() async {
    Uri uri;
    if (isRegClient == true) {
      uri = Uri.http('gymapp.amadeya.net', '/api.php', {
        'apiv': '1',
        'action': 'auth',
        'object': 'registerclient',
        'login': _loginTextController.text,
        'pass': _passwordTextController.text,
        'name': _nameTextController.text,
        'age': _ageTextController.text,
        'gender': _genderTextController.text,
        'cardnumber': _cardnumberTextController.text,
      });
    } else {
      uri = Uri.http('gymapp.amadeya.net', '/api.php', {
        'apiv': '1',
        'action': 'auth',
        'object': 'registertutor',
        'login': _loginTextController.text,
        'pass': _passwordTextController.text,
        'name': _nameTextController.text,
        'age': _ageTextController.text,
        'gender': _genderTextController.text,
        'type_of_training': _trainingTextController.text,
        'cost': _costTextController.text,
      });
    }
    dynamic auth = await http.get(uri);
    var decodedResponse = jsonDecode(utf8.decode(auth.bodyBytes)) as Map;
    String jsonString = jsonEncode(decodedResponse['data']);

    try {
      final json = await jsonDecode(jsonString) as dynamic;
      me = json
          .map((dynamic e) => Me.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (error) {}
  }

  void _changeState() {
    isRegist
        ? (setState(() {
            isRegist = false;
          }))
        : (setState(() {
            isRegist = true;
          }));
  }

  void _changeRegState() {
    isRegClient
        ? (setState(() {
            isRegClient = false;
          }))
        : (setState(() {
            isRegClient = true;
          }));
  }

  void updateFocus(String field, bool isFocused) {
    setState(() {
      switch (field) {
        case 'login':
          isLoginFocused = isFocused;
          isPasswordFocused = false;
          isNameFocused = false;
          isAgeFocused = false;
          isGenderFocused = false;
          isCardnumberFocused = false;
          isCostFocused = false;
          isTrainingFocused = false;
          break;
        case 'password':
          isLoginFocused = false;
          isPasswordFocused = isFocused;
          isNameFocused = false;
          isAgeFocused = false;
          isGenderFocused = false;
          isCardnumberFocused = false;
          isCostFocused = false;
          isTrainingFocused = false;
          break;
        case 'name':
          isLoginFocused = false;
          isPasswordFocused = false;
          isNameFocused = isFocused;
          isAgeFocused = false;
          isGenderFocused = false;
          isCardnumberFocused = false;
          isCostFocused = false;
          isTrainingFocused = false;
          break;
        case 'age':
          isLoginFocused = false;
          isPasswordFocused = false;
          isNameFocused = false;
          isAgeFocused = isFocused;
          isGenderFocused = false;
          isCardnumberFocused = false;
          isCostFocused = false;
          isTrainingFocused = false;
          break;
        case 'gender':
          isLoginFocused = false;
          isPasswordFocused = false;
          isNameFocused = false;
          isAgeFocused = false;
          isGenderFocused = isFocused;
          isCardnumberFocused = false;
          isCostFocused = false;
          isTrainingFocused = false;
          break;
        case 'cardnumber':
          isLoginFocused = false;
          isPasswordFocused = false;
          isNameFocused = false;
          isAgeFocused = false;
          isGenderFocused = false;
          isCardnumberFocused = isFocused;
          isCostFocused = false;
          isTrainingFocused = false;
          break;
        case 'cost':
          isLoginFocused = false;
          isPasswordFocused = false;
          isNameFocused = false;
          isAgeFocused = false;
          isGenderFocused = false;
          isCardnumberFocused = false;
          isCostFocused = isFocused;
          isTrainingFocused = false;
          break;
        case 'training':
          isLoginFocused = false;
          isPasswordFocused = false;
          isNameFocused = false;
          isAgeFocused = false;
          isGenderFocused = false;
          isCardnumberFocused = false;
          isCostFocused = false;
          isTrainingFocused = isFocused;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isRegist ? "Регистрация" : "Авторизация",
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10, left: 15, right: 15, bottom: 30),
                  child: AuthTextField(
                    loginTextController: _loginTextController,
                    label: 'Введите логин',
                    isFocused: isLoginFocused,
                    onFocusChanged: (isFocused) =>
                        updateFocus('login', isFocused),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 30),
                  child: AuthTextField(
                    loginTextController: _passwordTextController,
                    label: 'Введите пароль',
                    isFocused: isPasswordFocused,
                    onFocusChanged: (isFocused) =>
                        updateFocus('password', isFocused),
                  ),
                ),
                isRegist
                    ? (Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 30),
                          child: AuthTextField(
                            loginTextController: _nameTextController,
                            label: 'Введите имя',
                            isFocused: isNameFocused,
                            onFocusChanged: (isFocused) =>
                                updateFocus('name', isFocused),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 30),
                          child: AuthTextField(
                            loginTextController: _ageTextController,
                            label: 'Введите возраст',
                            isFocused: isAgeFocused,
                            onFocusChanged: (isFocused) =>
                                updateFocus('age', isFocused),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 30),
                          child: AuthTextField(
                            loginTextController: _genderTextController,
                            label: 'Введите пол',
                            isFocused: isGenderFocused,
                            onFocusChanged: (isFocused) =>
                                updateFocus('gender', isFocused),
                          ),
                        ),
                        isRegClient
                            ? (Column(children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, bottom: 30),
                                  child: AuthTextField(
                                    loginTextController:
                                        _cardnumberTextController,
                                    label: 'Введите номер карты',
                                    isFocused: isCardnumberFocused,
                                    onFocusChanged: (isFocused) =>
                                        updateFocus('cardnumber', isFocused),
                                  ),
                                ),
                              ]))
                            : (Column(children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, bottom: 30),
                                  child: AuthTextField(
                                    loginTextController:
                                        _trainingTextController,
                                    label: 'Введите тип тренировок',
                                    isFocused: isTrainingFocused,
                                    onFocusChanged: (isFocused) =>
                                        updateFocus('training', isFocused),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, bottom: 30),
                                  child: AuthTextField(
                                    loginTextController: _costTextController,
                                    label: 'Введите тип тренировок',
                                    isFocused: isCostFocused,
                                    onFocusChanged: (isFocused) =>
                                        updateFocus('cost', isFocused),
                                  ),
                                ),
                              ])),
                      ]))
                    : Container(),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                  child: TextButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        )),
                        backgroundColor:
                            MaterialStateProperty.all(kPrimaryColor)),
                    onPressed: isRegist ? _regist : _auth,
                    child: Text(
                      isRegist ? "Зарегистрироваться" : "Авторизоваться",
                      style: const TextStyle(color: kWhiteColor),
                    ),
                  ),
                ),
                isRegist
                    ? Padding(
                        padding:
                            const EdgeInsets.only(top: 15, left: 15, right: 15),
                        child: TextButton(
                          onPressed: _changeRegState,
                          child: Text(
                            isRegClient
                                ? "Стать тренером"
                                : "Зарегистрироваться как клиент",
                            style: const TextStyle(color: kWhiteColor),
                          ),
                        ),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 15, left: 15, right: 15, bottom: 15),
                  child: TextButton(
                    onPressed: _changeState,
                    child: Text(
                      isRegist ? "У меня есть аккаунт" : "У меня нет аккаунта",
                      style: const TextStyle(color: kWhiteColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
