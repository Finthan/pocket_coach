import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pocket_coach/screens/workout/components/title_and_age.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;

import '../../../all_class.dart';
import '../../../constants.dart';
import '../../../main.dart';
import '../../auth_registration/auth_registration_screen.dart';
import 'custom_alert_dialog.dart';
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
  var id = [];

  late bool _isAuth;

  @override
  void initState() {
    super.initState();
    _isAuth = Main.isAuth;
    isClient ? clientTrainings() : fetchTrainings();
  }

  Future<void> fetchTrainings() async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'get',
      'object': 'tutorworkouts',
      'id_client': widget.id,
      'id_tutor': tutorMe.id.toString(),
    });
    var response;
    try {
      response = await http.get(uri);
    } catch (error) {}
    String jsonString = "";
    if (response.statusCode == 200 && _isAuth == true) {
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      jsonString = jsonEncode(decodedResponse['data']);
    }
    try {
      final json = await jsonDecode(jsonString) as List<dynamic>;
      if (json.isNotEmpty) {
        setState(() {
          trainings = json
              .map((dynamic e) => Training.fromJson(e as Map<String, dynamic>))
              .toList();
        });
      }
    } catch (error) {}
  }

  Future<void> clientTrainings() async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'get',
      'object': 'clientworkouts',
      'id_client': clientMe.id,
    });
    var response;
    try {
      response = await http.get(uri);
    } catch (error) {}
    String jsonString = "";
    if (response.statusCode == 200 && _isAuth == true) {
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      jsonString = jsonEncode(decodedResponse['data']);
    }
    try {
      final json = await jsonDecode(jsonString) as List<dynamic>;
      if (json.isNotEmpty) {
        setState(() {
          trainings = json
              .map((dynamic e) => Training.fromJson(e as Map<String, dynamic>))
              .toList();
        });
      }
    } catch (error) {}
  }

  Future<void> deleteTrainings(id) async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'set',
      'object': 'delworkout',
      'id_workout': id,
      'id_tutor': widget.id,
    });
    var response;

    try {
      response = await http.get(uri);
    } catch (error) {}
    String jsonString = "";
    if (response.statusCode == 200 && _isAuth == true) {
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      jsonString = jsonEncode(decodedResponse['data']);
    }
    try {
      final json = await jsonDecode(jsonString) as List<dynamic>;
      if (json.isNotEmpty) {
        setState(() {
          trainings = json
              .map((dynamic e) => Training.fromJson(e as Map<String, dynamic>))
              .toList();
        });
      }
    } catch (error) {}
  }

  void updateTrainings(List<Training> newTrainings) {
    setState(() {
      trainings = newTrainings;
    });
  }

  void _handleCellLongPress(CalendarLongPressDetails details) {
    if (details.appointments == null || details.appointments!.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            id: widget.id,
            isAuth: _isAuth,
            trainings: trainings,
            onUpdateTrainings: updateTrainings,
            details: details,
          );
        },
      );
    }
  }

  void _showDeleteConfirmationDialog(Training appointment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Удалить тренировку?',
            style: TextStyle(color: Colors.black87),
          ),
          content: Text(
            "Вы уверены, что хотите удалить эту тренировку ${appointment.dateTime}?",
            style: const TextStyle(color: Colors.black54),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Отмена',
                style: TextStyle(color: Colors.black54),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Удалить'),
              onPressed: () {
                deleteTrainings(appointment.id);
                setState(() {
                  trainings.removeWhere((t) => t.id == appointment.id);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateTime todayDay = DateTime.now();
    print(todayDay);
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
      List<DateTime> dates = trainings
          .map((training) => DateTime.parse(training.dateTime))
          .toList();

      // Отсортируем список объектов DateTime
      dates.sort();

      // Преобразуем отсортированные объекты DateTime обратно в объекты Training
      List<Training> sortedTrainings = dates.map((date) {
        return trainings.firstWhere(
            (training) => DateTime.parse(training.dateTime) == date);
      }).toList();
      setState(() {
        trainings.replaceRange(0, trainings.length, sortedTrainings);
      });

      try {
        print("${trainings[0].id} ${trainings[0].dateTime} ${trainings[1].id}");
      } catch (e) {}
      int? day;
      int? month;
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
            id.add(trainings[j].id);
            day = DateTime.parse(trainings[j].dateTime).day;
            month = DateTime.parse(trainings[j].dateTime).month;
            nameWorkout[i] = trainings[j].nameWorkout;
            iconWorkout[i] = trainings[j].nameIcon;
            break;
          }
        }
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
      day = null;
      month = null;
      week.clear();
    }

    return Stack(
      children: [
        ListView(
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
                                    id: id[i],
                                  ),
                                ),
                              );
                            }
                          },
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.only(top: 5, left: 20),
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
                              padding:
                                  const EdgeInsets.only(right: 10, bottom: 5),
                              child: Text(
                                nameWorkout[i],
                                style: const TextStyle(color: kTextSideScreens),
                              ),
                            ),
                            subtitle: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Text(
                                  weekList[i],
                                  style:
                                      const TextStyle(color: kTextSideScreens),
                                )),
                          ),
                        ),
                    ],
                  )
                : TitleAndPrice(
                    title: widget.name,
                    status: widget.status,
                    age: widget.age,
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
                  appointmentDisplayMode:
                      MonthAppointmentDisplayMode.appointment,
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  );
                },
                onTap: (CalendarTapDetails details) {
                  if (!isClient) {
                    if (details.appointments != null &&
                        details.appointments!.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Exercise(
                            training: details.appointments!.first as Training,
                          ),
                        ),
                      );
                    }
                  }
                },
                onLongPress: (CalendarLongPressDetails details) {
                  if (!isClient) {
                    var isTraining = false;
                    for (var i = 0; i < trainings.length; i++) {
                      var string_1 = details.date
                          .toString()
                          .substring(0, details.date.toString().length - 4);
                      var string_2 = trainings[i]
                          .dateTime
                          .substring(0, trainings[i].dateTime.length - 1);
                      if (string_1 == string_2) {
                        isTraining = true;
                      }
                    }
                    if (isTraining) {
                      if (!isClient) {
                        _showDeleteConfirmationDialog(
                            details.appointments!.first);
                      }
                    } else {
                      _handleCellLongPress(details);
                    }
                  }
                },
              ),
            ),
            Container(height: 70),
          ],
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: kPrimaryColor,
            ),
            child: const Icon(
              Icons.chat,
              color: kWhiteColor,
              size: 30,
            ),
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
        .add(const Duration(hours: 1));
  }
}
