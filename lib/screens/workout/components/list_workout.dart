import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pocket_coach/screens/workout/components/title_and_age.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;

import '../../../all_class.dart';
import '../../../constants.dart';
import '../../../main.dart';
import '../../auth_registration.dart/auth_registration_screen.dart';
import 'create_workout.dart';
import 'exercise.dart';
import 'workout.dart';

class ListWorkout extends StatefulWidget {
  const ListWorkout({
    super.key,
    required this.name,
    required this.status,
    required this.id,
    required this.age,
  });

  final String name, status, id, age;

  @override
  State<ListWorkout> createState() => _ListWorkoutState();
}

class _ListWorkoutState extends State<ListWorkout>
    with SingleTickerProviderStateMixin {
  List<Training> trainings = [];

  @override
  void initState() {
    super.initState();
    isClient ? clientTrainings() : fetchTrainings();
  }

  Future<void> fetchTrainings() async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'get',
      'object': 'tutorworkouts',
      'id_client': widget.id,
      'id_tutor': tutorMe[0].id.toString(),
    });
    var response;
    try {
      response = await http.get(uri);
    } catch (error) {
      print('myClients $error');
    }
    String jsonString = "";
    if (response.statusCode == 200 && isAuth == true) {
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      jsonString = jsonEncode(decodedResponse['data']);
    }
    try {
      final json = await jsonDecode(jsonString) as List<dynamic>;
      //print(jsonString);
      if (json.length > 0) {
        setState(() {
          trainings = json
              .map((dynamic e) => Training.fromJson(e as Map<String, dynamic>))
              .toList();
        });
      }
    } catch (error) {
      print('ошибка форматирования json myClients $error');
    }
  }

  Future<void> clientTrainings() async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'get',
      'object': 'clientworkouts',
      'id_client': clientMe[0].id,
    });
    var response;
    try {
      response = await http.get(uri);
    } catch (error) {
      print('myClients $error');
    }
    String jsonString = "";
    if (response.statusCode == 200 && isAuth == true) {
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      jsonString = jsonEncode(decodedResponse['data']);
    }
    try {
      final json = await jsonDecode(jsonString) as List<dynamic>;
      //print(jsonString);
      if (json.length > 0) {
        setState(() {
          trainings = json
              .map((dynamic e) => Training.fromJson(e as Map<String, dynamic>))
              .toList();
        });
      }
    } catch (error) {
      print('ошибка форматирования json myClients $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(clientMe[0].id);
    final DateTime todayDay = DateTime.now();
    var weekList = ["", "", ""];
    var nameWorkout = [
      "Нет запланированной тренировки",
      "Нет запланированной тренировки",
      "Нет запланированной тренировки",
    ];
    var iconWorkout = [
      "assets/images/icon_no.png",
      "assets/images/icon_no.png",
      "assets/images/icon_no.png",
    ];
    if (isClient) {
      print("отображение тренировок");
      var day;
      var month;
      var week = [0, 0, 0];
      DateTime trainingWeek = DateTime.parse(todayDay.toString());
      for (var i = 0; i < 3; i++) {
        day = 0;
        month = 0;
        for (var j = 0; j < trainings.length; j++) {
          if (todayDay.year <= DateTime.parse(trainings[j].dateTime).year &&
              todayDay.month <= DateTime.parse(trainings[j].dateTime).month &&
              todayDay.day <= DateTime.parse(trainings[j].dateTime).day &&
              week[0] != DateTime.parse(trainings[j].dateTime).weekday &&
              week[1] != DateTime.parse(trainings[j].dateTime).weekday) {
            trainingWeek = DateTime.parse(trainings[j].dateTime);
            week[i] = DateTime.parse(trainings[j].dateTime).weekday;
            day = DateTime.parse(trainings[j].dateTime).day;
            month = DateTime.parse(trainings[j].dateTime).month;
            nameWorkout[i] = trainings[j].nameWorkout;
            iconWorkout[i] = trainings[j].nameIcon;
            break;
          }
        }
        print(" ${nameWorkout[0]} ${nameWorkout[1]} ${nameWorkout[2]}");
        if (todayDay.day == day && todayDay.month == month) {
          weekList[i] = "Сегодня";
        } else if (todayDay.day + 1 == day && todayDay.month == month) {
          weekList[i] = "Завтра";
        } else if (day != 0) {
          switch (trainingWeek.weekday) {
            case 1:
              weekList[i] = "Понедельник $day.$month";
              break;
            case 2:
              weekList[i] = "Вторник $day.$month";
              break;
            case 3:
              weekList[i] = "Среда $day.$month";
              break;
            case 4:
              weekList[i] = "Четверг $day.$month";
              break;
            case 5:
              weekList[i] = "Пятница $day.$month";
              break;
            case 6:
              weekList[i] = "Суббота $day.$month";
              break;
            case 7:
              weekList[i] = "Воскресенье $day.$month";
              break;
          }
        }
      }
    }

    return ListView(
      children: [
        isClient
            ? Column(
                children: [
                  Container(
                    height: 55,
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(
                      top: 15,
                      left: 20,
                    ),
                    child: const Text(
                      "Планируемые тренировки",
                      style: TextStyle(
                        color: kWhiteColor,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 17, right: 17),
                    child: Divider(
                      color: kPrimaryColor,
                      height: 1,
                    ),
                  ),
                  for (var i = 0; i < 3; i++)
                    GestureDetector(
                      onTap: () {
                        if (i == 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Workout(
                                title: nameWorkout[i],
                                id: trainings[i].id,
                              ),
                            ),
                          );
                        }
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(top: 5, left: 20),
                        leading: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 5),
                                blurRadius: 2,
                                color: kPrimaryColor.withOpacity(0.80),
                              ),
                            ],
                            image: DecorationImage(
                              alignment: Alignment.center,
                              fit: BoxFit.cover,
                              image: AssetImage(
                                iconWorkout[i],
                              ),
                            ),
                          ),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(right: 10, bottom: 5),
                          child: Text(
                            nameWorkout[i],
                            style: const TextStyle(color: kTextSideScreens),
                          ),
                        ),
                        subtitle: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              weekList[i],
                              style: const TextStyle(color: kTextSideScreens),
                            )),
                      ),
                    ),
                ],
              )
            : Column(
                children: [
                  TitleAndPrice(
                    title: widget.name,
                    status: widget.status,
                    age: widget.age,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: Center(
                      child: TextButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.only(
                                    left: 15, top: 15, bottom: 15)),
                            backgroundColor:
                                MaterialStateProperty.all(kPrimaryColor)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateWorkout(
                                id: widget.id,
                              ),
                            ),
                          );
                        },
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Создать тренировку",
                              style: TextStyle(
                                  color: kTextSideScreens, fontSize: 15),
                              textAlign: TextAlign.left),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

        //TODO Break
        Container(
          height: 55,
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(
            top: 15,
            left: 20,
          ),
          child: const Text(
            "График тренировок",
            style: TextStyle(
              color: kWhiteColor,
              fontSize: 20,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 17, right: 17),
          child: Divider(
            color: kPrimaryColor,
            height: 1,
          ),
        ),
        SizedBox(
          height: 500,
          child: SfCalendar(
            firstDayOfWeek: 1,
            view: CalendarView.month,
            dataSource: TrainingDataSource(trainings),
            headerStyle: const CalendarHeaderStyle(
              textStyle: TextStyle(
                color: kWhiteColor,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            monthViewSettings: const MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
              appointmentDisplayCount: 3,
              showTrailingAndLeadingDates: true,
              dayFormat: 'EE',
              monthCellStyle: MonthCellStyle(
                textStyle: TextStyle(color: kCalendarColor),
              ),
            ),
            todayHighlightColor: kCalendarColor,
            cellBorderColor: kPrimaryColor,
            appointmentBuilder:
                (BuildContext context, CalendarAppointmentDetails details) {
              return Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Color(details.appointments.first.colors),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    details.appointments.first.typeWorkout,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              );
            },
            onTap: (CalendarTapDetails details) {
              isClient
                  ? {
                      if (details.appointments != null &&
                          details.appointments!.isNotEmpty)
                        {}
                    }
                  : {
                      if (details.appointments != null &&
                          details.appointments!.isNotEmpty)
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Exercise(
                                training:
                                    details.appointments!.first as Training,
                              ),
                            ),
                          )
                        }
                    };
            },
          ),
        ),
      ],
    );
  }
}

class TrainingDataSource extends CalendarDataSource {
  TrainingDataSource(List<Training> source) {
    appointments = source;
  }

  @override
  String getSubject(int index) {
    return (appointments![index] as Training).typeWorkout;
  }

  @override
  Color getColor(int index) {
    return Color((appointments![index] as Training).colors);
  }

  @override
  DateTime getStartTime(int index) {
    return DateTime.parse((appointments![index] as Training).dateTime);
  }

  @override
  DateTime getEndTime(int index) {
    return DateTime.parse((appointments![index] as Training).dateTime)
        .add(Duration(hours: 1));
  }
}
