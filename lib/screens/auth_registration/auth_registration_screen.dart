import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../all_class.dart';
import 'components/auth_text_field.dart';

class AuthRegistrationScreen extends StatefulWidget {
  const AuthRegistrationScreen({super.key});

  @override
  State<AuthRegistrationScreen> createState() => _AuthRegistrationScreenState();
}

var isRegClient = true;

class _AuthRegistrationScreenState extends State<AuthRegistrationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  var isRegist = false;
  final _loginTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _nameTextController = TextEditingController();
  final _ageTextController = TextEditingController();
  final _numberTextController = TextEditingController();
  final _genderTextController = TextEditingController();
  final _trainingTextController = TextEditingController();
  final _costTextController = TextEditingController();
  final _cardnumberTextController = TextEditingController();

  Map<String, bool> fieldFocus = {
    'login': false,
    'password': false,
    'name': false,
    'age': false,
    'number': false,
    'gender': false,
    'cardnumber': false,
    'cost': false,
    'training': false,
  };

  Future<void> _auth(BuildContext context) async {
    String login = _loginTextController.text;
    String password = _passwordTextController.text;

    var provider = Provider.of<MeModel>(context, listen: false);
    await provider.loadAuthByClick(login, password);
  }

  Future<void> _regist(BuildContext context) async {
    Map<String, String> dataTextField = {
      'login': _loginTextController.text,
      'password': _passwordTextController.text,
      'name': _nameTextController.text,
      'age': _ageTextController.text,
      'number': _numberTextController.text,
      'gender': _genderTextController.text,
      'cardnumber': _cardnumberTextController.text,
      'cost': _costTextController.text,
      'training': _trainingTextController.text,
    };
    var provider = Provider.of<MeModel>(context, listen: false);
    await provider.loadRegistByClick(dataTextField, isRegClient);
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
      fieldFocus.forEach((key, value) {
        fieldFocus[key] = key == field ? isFocused : false;
      });
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
                    isFocused: fieldFocus['login']!,
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
                    isFocused: fieldFocus['password']!,
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
                            isFocused: fieldFocus['name']!,
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
                            isFocused: fieldFocus['age']!,
                            onFocusChanged: (isFocused) =>
                                updateFocus('age', isFocused),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 30),
                          child: AuthTextField(
                            loginTextController: _numberTextController,
                            label: 'Введите номер телефона',
                            isFocused: fieldFocus['number']!,
                            onFocusChanged: (isFocused) =>
                                updateFocus('number', isFocused),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 30),
                          child: AuthTextField(
                            loginTextController: _genderTextController,
                            label: 'Введите пол',
                            isFocused: fieldFocus['gender']!,
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
                                    isFocused: fieldFocus['cardnumber']!,
                                    onFocusChanged: (isFocused) =>
                                        updateFocus('cardnumber', isFocused),
                                  ),
                                ),
                              ]))
                            : (Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15, bottom: 30),
                                    child: AuthTextField(
                                      loginTextController:
                                          _trainingTextController,
                                      label: 'Введите тип тренировок',
                                      isFocused: fieldFocus['training']!,
                                      onFocusChanged: (isFocused) =>
                                          updateFocus(
                                              'type_of_training', isFocused),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15, bottom: 30),
                                    child: AuthTextField(
                                      loginTextController: _costTextController,
                                      label: 'Введите цену тренировки',
                                      isFocused: fieldFocus['cost']!,
                                      onFocusChanged: (isFocused) =>
                                          updateFocus('cost', isFocused),
                                    ),
                                  ),
                                ],
                              )),
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
                    onPressed: () {
                      isRegist ? _regist(context) : _auth(context);
                    },
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
