import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';
import '../../info.dart';
import '../../main.dart';
import '../../all_class.dart';

class AuthRegistrationScreen extends StatefulWidget {
  const AuthRegistrationScreen({super.key});

  @override
  State<AuthRegistrationScreen> createState() => _AuthRegistrationScreenState();
}

List<dynamic> tutorMe = [
  Tutor(
    id: '',
    name: '',
    age: '',
    gender: '',
    typeOfTraining: '',
    cost: '',
  ),
];

List<dynamic> clientMe = [
  Client(
    id: '',
    name: '',
    age: '',
    gender: '',
    cardnumber: '',
  ),
];

var isClient = true;
var isRegClient = true;

class _AuthRegistrationScreenState extends State<AuthRegistrationScreen> {
  var isRegist = false;
  final _loginTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _nameTextController = TextEditingController();
  final _ageTextController = TextEditingController();
  final _genderTextController = TextEditingController();
  final _trainingTextController = TextEditingController();
  final _costTextController = TextEditingController();
  final _cardnumberTextController = TextEditingController();

  Future<void> _auth() async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'auth',
      'object': 'login',
      'login': '${_loginTextController.text}',
      'pass': '${_passwordTextController.text}',
    });

    dynamic auth = await http.get(uri);
    var decodedResponse = jsonDecode(utf8.decode(auth.bodyBytes)) as Map;
    String jsonString = jsonEncode(decodedResponse['data']);

    try {
      final json = await jsonDecode(jsonString) as dynamic;
      setState(() {
        me = json
            .map((dynamic e) => Me.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      Uri checkClient = Uri.http('gymapp.amadeya.net', '/api.php', {
        'apiv': '1',
        'action': 'auth',
        'object': 'checkclient',
        'id': me[0].id.toString(),
      });

      Uri checkTutor = Uri.http('gymapp.amadeya.net', '/api.php', {
        'apiv': '1',
        'action': 'auth',
        'object': 'checktutor',
        'id': me[0].id.toString(),
      });

      dynamic check_client = await http.get(checkClient);
      var decodedClient =
          jsonDecode(utf8.decode(check_client.bodyBytes)) as Map;
      String clientString = jsonEncode(decodedClient['data']);

      dynamic check_tutor = await http.get(checkTutor);
      var decodedTutor = jsonDecode(utf8.decode(check_tutor.bodyBytes)) as Map;
      String tutorString = jsonEncode(decodedTutor['data']);

      try {
        if (clientString.length > 2) {
          final jsonC = await jsonDecode(clientString) as dynamic;
          clientMe = jsonC
              .map((dynamic e) => Client.fromJson(e as Map<String, dynamic>))
              .toList();
          isClient = true;
        } else if (tutorString.length > 2) {
          final jsonT = await jsonDecode(tutorString) as dynamic;
          tutorMe = jsonT
              .map((dynamic e) => Tutor.fromJson(e as Map<String, dynamic>))
              .toList();
          isClient = false;
        }
      } catch (error) {
        print('Не добавляется auth1 $error');
      }
    } catch (error) {
      print('Не добавляется auth2 $error');
    }
    try {
      if (me[0].id != "-0") {
        setState(() {
          isAuth = true;
          runApp(const Main());
        });
      } else {
        setState(() {
          isAuth = false;
        });
      }
    } catch (error) {
      print('Не добавляется auth3 $error');
    }
  }

  Future<void> _regist() async {
    List<dynamic> me = [
      Me(id: "-0"),
    ];
    Uri uri;
    if (isRegClient == true) {
      uri = Uri.http('gymapp.amadeya.net', '/api.php', {
        'apiv': '1',
        'action': 'auth',
        'object': 'registerclient',
        'login': '${_loginTextController.text}',
        'pass': '${_passwordTextController.text}',
        'name': '${_nameTextController.text}',
        'age': '${_ageTextController.text}',
        'gender': '${_genderTextController.text}',
        'cardnumber': '${_cardnumberTextController.text}',
      });
    } else {
      uri = Uri.http('gymapp.amadeya.net', '/api.php', {
        'apiv': '1',
        'action': 'auth',
        'object': 'registertutor',
        'login': '${_loginTextController.text}',
        'pass': '${_passwordTextController.text}',
        'name': '${_nameTextController.text}',
        'age': '${_ageTextController.text}',
        'gender': '${_genderTextController.text}',
        'type_of_training': '${_trainingTextController.text}',
        'cost': '${_costTextController.text}',
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
    } catch (error) {
      print(error);
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isRegist ? "Регистрация" : "Авторизация"),
      ),
      body: Center(
        child: SizedBox(
          height: isRegist ? 700 : 300,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 18, top: 15, bottom: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Введите логин",
                      style: TextStyle(color: kWhiteColor, fontSize: 17),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: TextField(
                    controller: _loginTextController,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                      hintText: "Введите текст... Nikita",
                      hintStyle: TextStyle(color: kTextChat),
                      isCollapsed: true,
                      filled: true,
                    ),
                    style: const TextStyle(color: kWhiteColor),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 18, top: 15, bottom: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Введите пароль",
                      style: TextStyle(color: kWhiteColor, fontSize: 17),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: TextField(
                    controller: _passwordTextController,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                      hintText: "Введите текст... pass",
                      hintStyle: TextStyle(color: kTextChat),
                      isCollapsed: true,
                      filled: true,
                    ),
                    obscureText: true,
                    style: const TextStyle(color: kWhiteColor),
                  ),
                ),
                isRegist
                    ? (Column(children: [
                        const Padding(
                          padding:
                              EdgeInsets.only(top: 10, left: 18, bottom: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Введите имя",
                              style:
                                  TextStyle(color: kWhiteColor, fontSize: 17),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: TextField(
                            controller: _nameTextController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 13),
                              hintText: "Введите текст... Никита",
                              hintStyle: TextStyle(color: kTextChat),
                              isCollapsed: true,
                              filled: true,
                            ),
                            style: const TextStyle(color: kWhiteColor),
                          ),
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.only(top: 10, left: 18, bottom: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Введите возраст",
                              style:
                                  TextStyle(color: kWhiteColor, fontSize: 17),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: TextField(
                            controller: _ageTextController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 13),
                              hintText: "Введите текст... 18",
                              hintStyle: TextStyle(color: kTextChat),
                              isCollapsed: true,
                              filled: true,
                            ),
                            style: const TextStyle(color: kWhiteColor),
                          ),
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.only(top: 10, left: 18, bottom: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Введите пол",
                              style:
                                  TextStyle(color: kWhiteColor, fontSize: 17),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: TextField(
                            controller: _genderTextController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 13),
                              hintText: "Введите текст... М",
                              hintStyle: TextStyle(color: kTextChat),
                              isCollapsed: true,
                              filled: true,
                            ),
                            style: const TextStyle(color: kWhiteColor),
                          ),
                        ),
                        isRegClient
                            ? (Column(children: [
                                const Padding(
                                  padding: EdgeInsets.only(
                                      top: 10, left: 18, bottom: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Введите номер карты",
                                      style: TextStyle(
                                          color: kWhiteColor, fontSize: 17),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  child: TextField(
                                    controller: _cardnumberTextController,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 13),
                                      hintText: "Введите текст... 1241342135",
                                      hintStyle: TextStyle(color: kTextChat),
                                      isCollapsed: true,
                                      filled: true,
                                    ),
                                    style: const TextStyle(color: kWhiteColor),
                                  ),
                                ),
                              ]))
                            : (Column(children: [
                                const Padding(
                                  padding: EdgeInsets.only(
                                      top: 10, left: 18, bottom: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Введите тип тренировок",
                                      style: TextStyle(
                                          color: kWhiteColor, fontSize: 17),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  child: TextField(
                                    controller: _trainingTextController,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 13),
                                      hintText: "Введите текст... Бодибилдинг",
                                      hintStyle: TextStyle(color: kTextChat),
                                      isCollapsed: true,
                                      filled: true,
                                    ),
                                    style: const TextStyle(color: kWhiteColor),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(
                                      top: 10, left: 18, bottom: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Введите цена за услуги",
                                      style: TextStyle(
                                          color: kWhiteColor, fontSize: 17),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  child: TextField(
                                    controller: _costTextController,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 13),
                                      hintText: "Введите текст... 1500",
                                      hintStyle: TextStyle(color: kTextChat),
                                      isCollapsed: true,
                                      filled: true,
                                    ),
                                    style: const TextStyle(color: kWhiteColor),
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
                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
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
