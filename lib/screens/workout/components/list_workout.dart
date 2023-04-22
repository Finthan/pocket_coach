import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../constants.dart';
import '../../../info.dart';
import 'workout.dart';

class ListWorkout extends StatefulWidget {
  const ListWorkout({
    super.key,
  });

  @override
  State<ListWorkout> createState() => _ListWorkoutState();
}

late Map<DateTime, List<Appointment>> _dataCollection;

class _ListWorkoutState extends State<ListWorkout>
    with SingleTickerProviderStateMixin {
  late var _calendarDataSource;

  @override
  void initState() {
    _dataCollection = getAppointments();
    _calendarDataSource = MeetingDataSource(<Appointment>[]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DateTime todayDay = DateTime.now();
    var weekList = ["", "", ""];
    var nameWorkout = [
      "Нет запланированной тренировки",
      "Нет запланированной тренировки",
      "Нет запланированной тренировки"
    ];
    var iconWorkout = [
      "assets/images/icon_no.png",
      "assets/images/icon_no.png",
      "assets/images/icon_no.png",
    ];
    var day;
    var month;
    var week = [0, 0, 0];
    DateTime trainingWeek = DateTime.parse(training[0].dateTime);
    for (var i = 0; i < 3; i++) {
      day = 0;
      month = 0;
      for (var j = 0; j < training.length; j++) {
        if (todayDay.year <= DateTime.parse(training[j].dateTime).year &&
            todayDay.month <= DateTime.parse(training[j].dateTime).month &&
            todayDay.day <= DateTime.parse(training[j].dateTime).day &&
            week[0] != DateTime.parse(training[j].dateTime).weekday &&
            week[1] != DateTime.parse(training[j].dateTime).weekday) {
          trainingWeek = DateTime.parse(training[j].dateTime);
          week[i] = DateTime.parse(training[j].dateTime).weekday;
          day = DateTime.parse(training[j].dateTime).day;
          month = DateTime.parse(training[j].dateTime).month;
          nameWorkout[i] = training[j].name;
          iconWorkout[i] = training[j].nameIcon;
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
        }
      }
    }
    return ListView(
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

        // SvgPicture.asset(
        //                   "assets/icons/back_arrow.svg",
        //                   color: kNavBarIconColor,
        //                 ),
        //TODO Поменять PNG на SVG
        for (var i = 0; i < 3; i++)
          GestureDetector(
            onTap: () {
              if (i == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Workout(
                      title: nameWorkout[i],
                      id: training[i].id,
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
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
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
          height: 490,
          child: SfCalendar(
            firstDayOfWeek: 1,
            headerStyle: const CalendarHeaderStyle(
              textStyle: TextStyle(
                color: kWhiteColor,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            view: CalendarView.month,
            monthViewSettings: const MonthViewSettings(
                appointmentDisplayCount: 3,
                showTrailingAndLeadingDates: true,
                dayFormat: 'EE',
                monthCellStyle: MonthCellStyle(
                  textStyle: TextStyle(color: kCalendarColor),
                ),
                appointmentDisplayMode:
                    MonthAppointmentDisplayMode.appointment),
            dataSource: _calendarDataSource,
            todayHighlightColor: kCalendarColor,
            cellBorderColor: kPrimaryColor,
            headerHeight: 50,
            loadMoreWidgetBuilder:
                (BuildContext context, LoadMoreCallback loadMoreAppointments) {
              return FutureBuilder(
                future: loadMoreAppointments(),
                builder: (context, snapShot) {
                  return Container(
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(kPrimaryColor),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Map<DateTime, List<Appointment>> getAppointments() {
    var _dataCollection = <DateTime, List<Appointment>>{};
    final DateTime today = DateTime.now();
    final DateTime rangeStartDate =
        DateTime(today.year, today.month, today.day);
    final DateTime rangeEndDate = DateTime(today.year, today.month, today.day)
        .add(const Duration(days: 30));
    for (DateTime i = rangeStartDate;
        i.isBefore(rangeEndDate);
        i = i.add(const Duration(days: 1))) {
      DateTime date = i;

      for (var j = 0; j < training.length; j++) {
        int count = training[j].workout.length;
        DateTime trainingTime = DateTime.parse(training[j].dateTime);

        if (DateTime(date.year, date.month, date.day) ==
            DateTime(trainingTime.year, trainingTime.month, trainingTime.day)) {
          for (int k = 0; k < count; k++) {
            final DateTime startDate =
                DateTime(date.year, date.month, date.day);
            final Appointment meeting = Appointment(
              subject: training[j].workout[k].toString(),
              startTime: startDate,
              endTime: startDate,
              color: Color(training[j].colors),
              isAllDay: false,
            );
            if (_dataCollection.containsKey(date)) {
              final List<Appointment> meetings = _dataCollection[date]!;
              meetings.add(meeting);
              _dataCollection[date] = meetings;
            } else {
              _dataCollection[date] = [meeting];
            }
          }
        }
      }
    }
    return _dataCollection;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }

  @override
  Future<void> handleLoadMore(DateTime startDate, DateTime endDate) async {
    await Future.delayed(const Duration(seconds: 1));
    final List<Appointment> meetings = <Appointment>[];
    DateTime appStartDate = startDate;
    DateTime appEndDate = endDate;

    while (appStartDate.isBefore(appEndDate)) {
      final List<Appointment>? data = _dataCollection[appStartDate];
      if (data == null) {
        appStartDate = appStartDate.add(const Duration(days: 1));
        continue;
      }
      for (final Appointment meeting in data) {
        if (appointments!.contains(meeting)) {
          continue;
        }
        meetings.add(meeting);
      }
      appStartDate = appStartDate.add(const Duration(days: 1));
    }
    appointments!.addAll(meetings);
    notifyListeners(CalendarDataSourceAction.add, meetings);
  }
}
