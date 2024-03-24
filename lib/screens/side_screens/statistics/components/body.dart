import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pocket_coach/constants.dart';
import 'package:rive/rive.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:http/http.dart' as http;

import '../../../../all_class.dart';
import '../../../../info.dart';
import '../../../../main.dart';
import '../../../../models/rive_asset.dart';
import '../../../auth_registration/auth_registration_screen.dart';
import '../../components_side/app_bar_side_screens.dart';
import 'line_chart_widget.dart';

String capitalizeFirstLetter(String word, int year) {
  return "${word.substring(0, 1).toUpperCase()}${word.substring(1)} $year";
}

String getMonthName(int month, int year) {
  initializeDateFormatting('ru', null);
  DateTime date = DateTime(year, month);
  String monthName = DateFormat.MMMM('ru').format(date);
  return capitalizeFirstLetter(monthName, year);
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool _isAuth = false;
  DateTime selectDay = DateTime(DateTime.now().year, DateTime.now().month);
  List<MadeApproachesChart> madeApproachesChart = [];
  List<ClientExercise> clientExercise = [];
  ConnectionState _connectionState = ConnectionState.waiting;

  int countWorkout = 0;
  int countMadeApproachesChart = 0;
  @override
  void initState() {
    super.initState();
    _isAuth = Main.isAuth;
    final DateTime todayDay = DateTime.now();
    selectDay = DateTime(todayDay.year, todayDay.month);
    madeApproachesList();
  }

  @override
  void dispose() {
    super.dispose();
    _isAuth = false;
  }

  void _showDatePicker() {
    final DateTime todayDay = DateTime.now();
    final initialDateTime = DateTime(selectDay.year, selectDay.month, 1);
    DatePicker.showDatePicker(
      context,
      pickerMode: DateTimePickerMode.date,
      initialDateTime: initialDateTime,
      minDateTime: DateTime(todayDay.year - 1),
      maxDateTime: DateTime(todayDay.year, todayDay.month),
      onConfirm: (dateTime, _) {
        setState(() {
          selectDay = DateTime(dateTime.year, dateTime.month);
        });
      },
    );
  }

  Future<List<MadeApproachesChart>> madeApproachesList() async {
    Uri uri;
    if (isClient) {
      uri = Uri.http('gymapp.amadeya.net', '/api.php', {
        'apiv': '1',
        'action': 'get',
        'object': 'madeclientapproaches',
        'id_user': me.id,
      });
    } else {
      uri = Uri.http('gymapp.amadeya.net', '/api.php', {
        'apiv': '1',
        'action': 'get',
        'object': 'madetutorapproaches',
        'id_user': me.id,
      });
    }
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
          madeApproachesChart = json
              .map((dynamic e) =>
                  MadeApproachesChart.fromJson(e as Map<String, dynamic>))
              .toList();
          countMadeApproachesChart = madeApproachesChart.length;
        });
      }
    } catch (error) {}
    setState(() {
      if (madeApproachesChart.isNotEmpty) {
        _connectionState = ConnectionState.done;
      }
    });
    return madeApproachesChart;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          AppBarSideScreens(
            riveOnInit: (Artboard value) {},
            menu: sideScreens[3],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 20,
                ),
                color: kWhiteColor,
              ),
              Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: GestureDetector(
                    onTap: _showDatePicker,
                    child: Text(
                      getMonthName(selectDay.month, selectDay.year),
                      style: TextStyle(
                        color: kWhiteColor,
                        fontSize: 20,
                      ),
                    ),
                  )),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 20,
                ),
                color: kWhiteColor,
              )
            ],
          ),
          Container(
            height: 500,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(
              left: 10,
              right: 20,
            ),
            child: FutureBuilder(
              future: madeApproachesList(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<MadeApproachesChart>> snapshot) {
                if (_connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return LineChartWidget(
                    madeApproachesChart: madeApproachesChart,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
