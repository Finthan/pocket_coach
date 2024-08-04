import 'package:flutter/material.dart';
import 'package:pocket_coach/constants.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../all_class.dart';

class ClientsWidget extends StatefulWidget {
  const ClientsWidget({
    super.key,
  });

  @override
  State<ClientsWidget> createState() => _ClientsWidget();
}

class _ClientsWidget extends State<ClientsWidget>
    with SingleTickerProviderStateMixin {
  final _timeTextController = TextEditingController();
  final _workoutTextController = TextEditingController();
  DateTime selectDay = DateTime(DateTime.now().year, DateTime.now().month);

  var countWork = 0;
  var time = "";
  var nameWorkout = "";

  @override
  void initState() {
    super.initState();
    final DateTime todayDay = DateTime.now();
    selectDay = DateTime(todayDay.year, todayDay.month, todayDay.day);
  }

  String capitalizeFirstLetter(int day, int month, int year) {
    return "$day $month} $year";
  }

  String getMonthName(int day, int month, int year) {
    String result;
    var o = '';
    if (day <= 9) {
      o = '0';
    }

    if (month <= 9) {
      result = "$o$day.0$month.$year";
    } else {
      result = "$day.$month.$year";
    }
    return result;
  }

  void _showDatePicker() {
    final DateTime todayDay = DateTime.now();
    final initialDateTime = DateTime(selectDay.year, selectDay.month, 1);
    DatePicker.showDatePicker(
      context,
      pickerMode: DateTimePickerMode.date,
      initialDateTime: initialDateTime,
      minDateTime: DateTime(todayDay.year, todayDay.month, todayDay.day),
      maxDateTime: DateTime(todayDay.year + 1, todayDay.month + 1),
      onConfirm: (dateTime, _) {
        setState(() {
          selectDay = DateTime(dateTime.year, dateTime.month, dateTime.day);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UsersModel>(
      builder: (context, usersModel, child) {
        int index = usersModel.indexAllClients;
        return Padding(
          padding: const EdgeInsets.only(top: 200),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 18, top: 15, bottom: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Выберите дату тренировки",
                    style: TextStyle(color: kWhiteColor, fontSize: 17),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18, right: 15),
                child: GestureDetector(
                  onTap: _showDatePicker,
                  child: Container(
                    color: kTextColorBox,
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      getMonthName(
                          selectDay.day, selectDay.month, selectDay.year),
                      style: const TextStyle(
                        color: kWhiteColor,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 18, top: 15, bottom: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Напишите название тренировки",
                    style: TextStyle(color: kWhiteColor, fontSize: 17),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: TextField(
                  controller: _workoutTextController,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                    hintText: "Напишите название тренировки",
                    hintStyle: TextStyle(
                      color: kTextChat,
                      fontSize: 15,
                    ),
                    isCollapsed: true,
                    filled: true,
                  ),
                  style: const TextStyle(color: kTextFieldColor),
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
                  onPressed: () {
                    setState(() {
                      time = _timeTextController.text;
                      nameWorkout = _workoutTextController.text;
                      Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
                        'apiv': '1',
                        'action': 'set',
                        'object': 'createworkout',
                        'id_tutor': usersModel.me.idTutor,
                        'id_client': usersModel.listOfAllClients[index].id,
                        'name_workout': nameWorkout,
                        'workout_date':
                            "${selectDay.year}-${selectDay.month}-${selectDay.day}",
                      });
                      http.get(uri);
                      Navigator.pop(context);
                    });
                  },
                  child: const Text(
                    "Создать тренировку",
                    style: TextStyle(color: kWhiteColor),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
