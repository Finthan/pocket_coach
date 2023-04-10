import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../all_class.dart';
import '../../../constants.dart';
import '../../../info.dart';

class ListWorkout extends StatefulWidget {
  const ListWorkout({super.key, required this.training});

  final List<Training> training;

  @override
  State<ListWorkout> createState() => _ListWorkoutState();
}

late Map<DateTime, List<Appointment>> _dataCollection;

class _ListWorkoutState extends State<ListWorkout> {
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
    var weekInt = [0, 0, 0];
    DateTime trainingWeek = DateTime.parse(widget.training[0].dateTime);
    for (var i = 0; i < 3; i++) {
      for (var j = 0; j < training.length; j++) {
        if (todayDay.year <= DateTime.parse(widget.training[j].dateTime).year &&
            todayDay.month <=
                DateTime.parse(widget.training[j].dateTime).month &&
            todayDay.day <= DateTime.parse(widget.training[j].dateTime).day &&
            weekInt[0] != DateTime.parse(widget.training[j].dateTime).weekday &&
            weekInt[1] != DateTime.parse(widget.training[j].dateTime).weekday) {
          trainingWeek = DateTime.parse(widget.training[j].dateTime);
          weekInt[i] = DateTime.parse(widget.training[j].dateTime).weekday;
          break;
        }
      }
      switch (trainingWeek.weekday) {
        case 1:
          weekList[i] = "Понедельник";
          break;
        case 2:
          weekList[i] = "Вторник";
          break;
        case 3:
          weekList[i] = "Среда";
          break;
        case 4:
          weekList[i] = "Четверг";
          break;
        case 5:
          weekList[i] = "Пятница";
          break;
        case 6:
          weekList[i] = "Суббота";
          break;
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
              color: kWiteColor,
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
        for (var j = 0; j < 3; j++)
          ListTile(
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
                    widget.training[j].nameIcon,
                  ),
                ),
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 5),
              child: Text(
                widget.training[j].name,
                style: const TextStyle(color: kTextSideScreens),
              ),
            ),
            subtitle: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  "${weekList[j]} ${DateTime.parse(widget.training[j].dateTime).day}.${DateTime.parse(widget.training[j].dateTime).month}",
                  style: const TextStyle(color: kTextSideScreens),
                )),
          ),
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
              color: kWiteColor,
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
                color: kWiteColor,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            view: CalendarView.month,
            monthViewSettings: const MonthViewSettings(
                appointmentDisplayCount: 3,
                showTrailingAndLeadingDates: true,
                dayFormat: 'EEE',
                monthCellStyle: MonthCellStyle(
                  textStyle: TextStyle(color: kCalendarColor),
                ),
                appointmentDisplayMode:
                    MonthAppointmentDisplayMode.appointment),
            dataSource: _calendarDataSource,
            todayHighlightColor: kPrimaryColor,
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
    final Random random = Random();
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
        int count = widget.training[j].workout.length;
        DateTime trainingTime = DateTime.parse(widget.training[j].dateTime);

        if (DateTime(date.year, date.month, date.day) ==
            DateTime(trainingTime.year, trainingTime.month, trainingTime.day)) {
          for (int k = 0; k < count; k++) {
            final DateTime startDate =
                DateTime(date.year, date.month, date.day);
            final Appointment meeting = Appointment(
              subject: widget.training[j].workout[k].toString(),
              startTime: startDate,
              endTime: startDate,
              color: Color(widget.training[j].colors),
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
