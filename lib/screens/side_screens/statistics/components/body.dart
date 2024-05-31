import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:pocket_coach/constants.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

import '../../../../all_class.dart';
import '../../../../models/rive_asset.dart';
import '../../components_side/app_bar_side_screens.dart';
import 'line_chart_widget.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<ClientExercise> clientExercise = [];

  int countWorkout = 0;
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
    return Consumer<MeModel>(
      builder: (contextModel, meModel, child) {
        meModel.fetchGetMonthName();
        meModel.fetchMadeApproachesList();
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              AppBarSideScreens(
                riveOnInit: (Artboard value) {},
                menu: sideScreens[1],
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
                      onTap: () {
                        final initialDateTime = DateTime(
                            meModel.selectDay.year, meModel.selectDay.month, 1);
                        DatePicker.showDatePicker(
                          context,
                          pickerMode: DateTimePickerMode.date,
                          initialDateTime: initialDateTime,
                          minDateTime: DateTime(
                            meModel.todayDay.year - 1,
                          ),
                          maxDateTime: DateTime(
                            meModel.todayDay.year,
                            meModel.todayDay.month,
                          ),
                          onConfirm: (dateTime, _) {
                            meModel.selectDay = DateTime(
                              dateTime.year,
                              dateTime.month,
                            );
                            meModel.fetchGetMonthName();
                          },
                        );
                      },
                      child: Text(
                        meModel.selectDayText!,
                        style: const TextStyle(
                          color: kWhiteColor,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
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
                child: meModel.madeApproachesChart != null
                    ? LineChartWidget(
                        selectDay: meModel.selectDay,
                      )
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }
}
