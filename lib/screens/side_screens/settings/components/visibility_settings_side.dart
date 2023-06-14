import 'package:flutter/material.dart';

import '../../../../components/auth_natification.dart';
import '../../../../constants.dart';
import '../../../../main.dart';
import '../../../../models/rive_asset.dart';
import 'button_settings.dart';

class VisibilitySettingsSide extends StatefulWidget {
  const VisibilitySettingsSide({
    super.key,
    required this.isActive,
    required this.menu,
    required this.onGlobalVariableChanged,
  });

  final bool isActive;
  final RiveAsset menu;
  final VoidCallback onGlobalVariableChanged;

  @override
  State<VisibilitySettingsSide> createState() => _VisibilitySettingsSideState();
}

class _VisibilitySettingsSideState extends State<VisibilitySettingsSide> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isActive,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 10, left: 60, right: 17, bottom: 20),
        child: Column(
          children: [
            if (widget.menu.title == "Уведомления")
              SwitchListTile.adaptive(
                title: const Text(
                  "Включить уведомления",
                  style: TextStyle(color: kTextSideScreens),
                ),
                contentPadding: const EdgeInsets.only(left: 15),
                activeColor: kPrimaryColor,
                inactiveTrackColor: kSwitch,
                value: enableNotifications,
                onChanged: (value) {
                  setState(() {
                    enableNotifications = value;
                  });
                },
              ),
            if (widget.menu.title == "Уведомления")
              SwitchListTile.adaptive(
                title: const Text(
                  "Напоминание о тренировках",
                  style: TextStyle(color: kTextSideScreens),
                ),
                contentPadding: const EdgeInsets.only(left: 15),
                activeColor: kPrimaryColor,
                inactiveTrackColor: kSwitch,
                value: trainingReminder,
                onChanged: (value) {
                  setState(() {
                    trainingReminder = value;
                  });
                },
              ),
            if (widget.menu.title == "Аккаунт")
              ButtonSettings(
                text: "Сменить пользователя",
                press: () {},
              ),
            if (widget.menu.title == "Аккаунт")
              ButtonSettings(
                text: "Поменять пароль",
                press: () {},
              ),
            if (widget.menu.title == "Аккаунт")
              ButtonSettings(
                text: "Выйти с аккаунта",
                press: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      actions: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              Main.isAuth = false;
                              Navigator.pop(context);
                              Navigator.pop(context);
                              AuthNotification(false).dispatch(context);
                            });
                          },
                          child: Text('Выйти'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              Navigator.pop(context);
                            });
                          },
                          child: Text('Отмена'),
                        ),
                      ],
                      title: Text('Выйти из аккаунта?'),
                      contentPadding: EdgeInsets.all(20.0),
                    ),
                  );
                },
              ),
            // if (widget.menu.title == "Внешний вид")
            //   SwitchListTile.adaptive(
            //     title: const Text(
            //       "Включить ночной режим",
            //       style: TextStyle(color: kTextSideScreens),
            //     ),
            //     contentPadding: const EdgeInsets.only(left: 15),
            //     activeColor: kPrimaryColor,
            //     inactiveTrackColor: kSwitch,
            //     value: nightMode,
            //     onChanged: (value) {
            //       setState(() {
            //         nightMode = value;
            //         if (nightMode == false) {
            //           kBackgroundColor = Color.fromRGBO(255, 255, 255, 1);
            //         } else {
            //           kBackgroundColor = Color.fromRGBO(94, 117, 128, 1);
            //         }
            //       });
            //     },
            //   ),
            // if (widget.menu.title == "Внешний вид")
            //   const ButtonSettings(text: "Изменить фон приложения"),
            if (widget.menu.title == "Приложение")
              SwitchListTile.adaptive(
                title: const Text(
                  "Сжимать фотографии",
                  style: TextStyle(color: kTextSideScreens),
                ),
                contentPadding: const EdgeInsets.only(left: 15),
                activeColor: kPrimaryColor,
                inactiveTrackColor: kSwitch,
                value: compressPhotos,
                onChanged: (value) {
                  setState(() {
                    compressPhotos = value;
                  });
                },
              ),
            if (widget.menu.title == "Приложение")
              SwitchListTile.adaptive(
                title: const Text(
                  "Сжимать видео",
                  style: TextStyle(color: kTextSideScreens),
                ),
                contentPadding: const EdgeInsets.only(left: 15),
                activeColor: kPrimaryColor,
                inactiveTrackColor: kSwitch,
                value: compressVideo,
                onChanged: (value) {
                  setState(() {
                    compressVideo = value;
                  });
                },
              ),
            // if (widget.menu.title == "Приложение")
            //   SwitchListTile.adaptive(
            //     title: const Text(
            //       "Данные о местоположении",
            //       style: TextStyle(color: kTextSideScreens),
            //     ),
            //     contentPadding: const EdgeInsets.only(left: 15),
            //     activeColor: kPrimaryColor,
            //     inactiveTrackColor: kSwitch,
            //     value: locationData,
            //     onChanged: (value) {
            //       setState(() {
            //         locationData = value;
            //       });
            //     },
            //   ),
          ],
        ),
      ),
    );
  }
}
