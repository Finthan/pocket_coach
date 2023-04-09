import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../all_class.dart';
import '../../../constants.dart';

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
                  widget.training[j].date,
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
    final List<String> _subjectCollection = <String>[];
    _subjectCollection.add('Ноги');
    _subjectCollection.add('Руки');
    _subjectCollection.add('Грудь');
    _subjectCollection.add('Бицепс');
    _subjectCollection.add('Трицепс');

    final List<Color> _colorCollection = <Color>[];
    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF36B37B));

    final Random random = Random();
    var _dataCollection = <DateTime, List<Appointment>>{};
    final DateTime today = DateTime.now();
    final DateTime rangeStartDate =
        DateTime(today.year, today.month, 1).add(const Duration(days: -30));
    final DateTime rangeEndDate = DateTime(today.year, today.month, today.day)
        .add(const Duration(days: 30));
    print(today);
    for (DateTime i = rangeStartDate;
        i.isBefore(rangeEndDate);
        i = i.add(const Duration(days: 2))) {
      final DateTime date = i;
      final int count = 2;
      for (int j = 0; j < count; j++) {
        final DateTime startDate = DateTime(date.year, date.month, date.day);
        final int duration = 2;
        final Appointment meeting = Appointment(
            subject: _subjectCollection[random.nextInt(5)],
            startTime: startDate,
            endTime:
                startDate.add(Duration(hours: duration == 0 ? 1 : duration)),
            color: _colorCollection[random.nextInt(5)],
            isAllDay: false);

        if (_dataCollection.containsKey(date)) {
          final List<Appointment> meetings = _dataCollection[date]!;
          meetings.add(meeting);
          _dataCollection[date] = meetings;
        } else {
          _dataCollection[date] = [meeting];
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
