import 'package:flutter/material.dart';
import 'package:pocket_coach/constants.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 300,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 18),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Введите логин",
                  style: TextStyle(color: kWhiteColor, fontSize: 20),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: TextField(
                strutStyle: StrutStyle(),
                style: TextStyle(color: kWhiteColor),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 18, top: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Введите пароль",
                  style: TextStyle(color: kWhiteColor, fontSize: 20),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: TextField(
                strutStyle: StrutStyle(),
                style: TextStyle(color: kWhiteColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
              child: TextButton(
                style: ButtonStyle(
                    shape:
                        MaterialStateProperty.all(const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    )),
                    backgroundColor: MaterialStateProperty.all(kPrimaryColor)),
                onPressed: () {},
                child: const Text(
                  "Авторизоваться",
                  style: TextStyle(color: kWhiteColor),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  "У меня нет аккаунта",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
