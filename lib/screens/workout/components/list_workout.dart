import 'package:flutter/material.dart';
import 'package:pocket_coach/screens/workout/components/title_and_age.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../all_class.dart';
import '../../../constants.dart';
import 'exercise.dart';
import 'workout.dart';

class ListWorkout extends StatefulWidget {
  const ListWorkout({
    super.key,
  });

  @override
  State<ListWorkout> createState() => _ListWorkoutState();
}

class _ListWorkoutState extends State<ListWorkout>
    with SingleTickerProviderStateMixin {
  var id = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TrainingModel>(
      builder: (context, trainingModel, child) {
        trainingModel.fetchUpdateTraining();

        final DateTime todayDay = DateTime.now();
        var weekList = ["", "", ""];
        var nameIconWorkout = [
          {
            "Нет запланированной тренировки",
            "assets/images/icon_no.png",
          },
          {
            "Нет запланированной тренировки",
            "assets/images/icon_no.png",
          },
          {
            "Нет запланированной тренировки",
            "assets/images/icon_no.png",
          },
        ];
        if (trainingModel.isClient && trainingModel.trainings != []) {
          List<DateTime> dates = trainingModel.trainings
              .map((training) => DateTime.parse(training.dateTime))
              .toList();

          dates.sort();

          List<Training> sortedTrainings = dates.map((date) {
            return trainingModel.trainings.firstWhere(
                (training) => DateTime.parse(training.dateTime) == date);
          }).toList();
          trainingModel.trainings
              .replaceRange(0, trainingModel.trainings.length, sortedTrainings);

          int? day;
          int? month;
          var week = [0, 0, 0];
          DateTime trainingWeek = DateTime.parse(todayDay.toString());
          for (var i = 0; i < 3; i++) {
            day = 0;
            month = 0;
            for (var j = 0; j < trainingModel.trainings.length; j++) {
              var dateTime =
                  DateTime.parse(trainingModel.trainings[j].dateTime);
              if (todayDay.year <= dateTime.year &&
                  todayDay.month <= dateTime.month &&
                  todayDay.day <= dateTime.day &&
                  week[0] != dateTime.weekday &&
                  week[1] != dateTime.weekday) {
                trainingWeek = dateTime;
                week[i] = dateTime.weekday;
                id.add(trainingModel.trainings[j].id);
                day = dateTime.day;
                month = dateTime.month;
                nameIconWorkout[i] = {
                  trainingModel.trainings[j].nameWorkout,
                  trainingModel.trainings[j].nameIcon
                };
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
                trainingModel.isClient
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
                                  trainingModel.idTraining = id[i];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Workout(
                                        title: nameIconWorkout[i].first,
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
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
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
                                        nameIconWorkout[i].last,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10, bottom: 5),
                                  child: Text(
                                    nameIconWorkout[i].first,
                                    style: const TextStyle(
                                        color: kTextSideScreens),
                                  ),
                                ),
                                subtitle: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Text(
                                      weekList[i],
                                      style: const TextStyle(
                                          color: kTextSideScreens),
                                    )),
                              ),
                            ),
                        ],
                      )
                    : const TitleAndPrice(),
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
                    dataSource: TrainingDataSource(trainingModel.trainings),
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
                    appointmentBuilder: (BuildContext context,
                        CalendarAppointmentDetails details) {
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
                      if (!trainingModel.isClient) {
                        if (details.appointments != null &&
                            details.appointments!.isNotEmpty) {
                          trainingModel.training =
                              details.appointments!.first as Training;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Exercise(),
                            ),
                          );
                        }
                      }
                    },
                    onLongPress: (CalendarLongPressDetails details) {
                      if (!trainingModel.isClient) {
                        var isTraining = false;
                        for (var i = 0;
                            i < trainingModel.trainings.length;
                            i++) {
                          var string_1 = details.date.toString().substring(
                                0,
                                details.date.toString().length - 4,
                              );
                          var string_2 = trainingModel.trainings[i].dateTime
                              .substring(
                                  0,
                                  trainingModel.trainings[i].dateTime.length -
                                      1);
                          if (string_1 == string_2) {
                            isTraining = true;
                            trainingModel.indexTrainings = i;
                          }
                        }
                        if (isTraining) {
                          if (!trainingModel.isClient) {
                            trainingModel.showDeleteConfirmationDialog(
                                details.appointments!.first, context);
                          }
                        } else {
                          trainingModel.handleCellLongPress(details, context);
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
                  child: IconButton(
                    onPressed: () {
                      var url =
                          'https://t.me/${trainingModel.isClient ? trainingModel.myTutor.number : trainingModel.listOfMyClients[trainingModel.index].number}';
                      launch(url);
                    },
                    icon: const Icon(
                      Icons.chat,
                      color: kWhiteColor,
                      size: 30,
                    ),
                  )),
            ),
          ],
        );
      },
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
