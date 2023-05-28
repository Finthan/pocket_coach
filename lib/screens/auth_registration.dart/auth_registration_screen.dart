import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';
import '../../main.dart';
import '../../all_class.dart';

class AuthRegistrationScreen extends StatefulWidget {
  const AuthRegistrationScreen({super.key});

  @override
  State<AuthRegistrationScreen> createState() => _AuthRegistrationScreenState();
}

List<dynamic> me = [
  Me(id: "-0"),
];

class _AuthRegistrationScreenState extends State<AuthRegistrationScreen> {
  var isRegist = false;
  final _loginTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _mailTextController = TextEditingController();

  Future<void> _auth() async {
    var login = utf8.encode(_loginTextController.text);
    var pass = utf8.encode(_passwordTextController.text);
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'auth',
      'object': 'login',
      'login': '$login',
      'pass': '$pass',
    });

    // Uri checkClient = Uri.http('gymapp.amadeya.net', '/api.php', {
    //   'apiv': '1',
    //   'action': 'auth',
    //   'object': 'checkclient',
    //   'id': '${me[0].id}',
    // });
    // Uri checkTutor = Uri.http('gymapp.amadeya.net', '/api.php', {
    //   'apiv': '1',
    //   'action': 'auth',
    //   'object': 'checktutor',
    //   'id': '${me[0].id}',
    // });

    dynamic auth = await http.get(uri);
    var decodedResponse = jsonDecode(utf8.decode(auth.bodyBytes)) as Map;
    String jsonString = jsonEncode(decodedResponse['data']);

    try {
      final json = await jsonDecode(jsonString) as dynamic;
      me = json
          .map((dynamic e) => Me.fromJson(e as Map<String, dynamic>))
          .toList();
      // dynamic check_client = await http.get(checkClient);
      // dynamic check_tutor = await http.get(checkTutor);

      // print(check_client);
      // print("//////");
      // print(check_tutor);
    } catch (error) {
      print(error);
    }
//gymapp.amadeya.net/api.php?apiv=1&action=auth&object=registertutor&login=Nik&pass=Никита$age=18$gender=М$name=Никита$cost=400$type_of_training=Бодибилдинг
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
  }

  void _regist() {
    print("regist");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isRegist ? "Регистрация" : "Авторизация"),
      ),
      body: Center(
        child: SizedBox(
          height: isRegist ? 400 : 300,
          child: Column(
            children: [
              isRegist
                  ? (Column(children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 18, bottom: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Введите почту",
                            style: TextStyle(color: kWhiteColor, fontSize: 17),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: TextField(
                          controller: _mailTextController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 13),
                            hintText: "Введите текст...",
                            hintStyle: TextStyle(color: kTextChat),
                            isCollapsed: true,
                            filled: true,
                          ),
                          style: const TextStyle(color: kWhiteColor),
                        ),
                      ),
                    ]))
                  : Container(),
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
                    hintText: "Введите текст...",
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
                    hintText: "Введите текст...",
                    hintStyle: TextStyle(color: kTextChat),
                    isCollapsed: true,
                    filled: true,
                  ),
                  obscureText: true,
                  style: const TextStyle(color: kWhiteColor),
                ),
              ),
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
    );
  }
}
