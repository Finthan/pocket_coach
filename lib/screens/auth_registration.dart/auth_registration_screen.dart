import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../main.dart';

class AuthRegistrationScreen extends StatefulWidget {
  const AuthRegistrationScreen({super.key});

  @override
  State<AuthRegistrationScreen> createState() => _AuthRegistrationScreenState();
}

class _AuthRegistrationScreenState extends State<AuthRegistrationScreen> {
  var isRegist = false;

  final _loginTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _mailTextController = TextEditingController();

  void _auth() {
    print("auth");
    if (_loginTextController.text == "Nikita" &&
        _passwordTextController.text == "Nikita") {
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
