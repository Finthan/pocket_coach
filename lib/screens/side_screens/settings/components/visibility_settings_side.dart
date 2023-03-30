import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../../models/rive_asset.dart';
import 'button_settings.dart';

class VisibilitySettingsSide extends StatefulWidget {
  const VisibilitySettingsSide({
    super.key,
    required this.isActive,
    required this.menu,
  });

  final bool isActive;
  final RiveAsset menu;

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
              const ButtonSettings(text: "Сменить пользователя"),
            if (widget.menu.title == "Аккаунт")
              const ButtonSettings(text: "Поменять пароль"),
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
            //           print("$nightMode $kBackgroundColor");
            //         } else {
            //           kBackgroundColor = Color.fromRGBO(94, 117, 128, 1);
            //           print("$nightMode $kBackgroundColor");
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
