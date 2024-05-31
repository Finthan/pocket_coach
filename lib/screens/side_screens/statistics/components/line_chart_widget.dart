import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pocket_coach/constants.dart';
import 'package:provider/provider.dart';

import '../../../../all_class.dart';

class LineChartWidget extends StatefulWidget {
  const LineChartWidget({
    super.key,
    required this.selectDay,
  });

  final DateTime selectDay;

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  int? selectedSpotIndex;
  @override
  Widget build(BuildContext context) {
    return Consumer<MeModel>(
      builder: (contextModel, meModel, child) {
        meModel.fetchMadeApproachesList();
        List<FlSpot> spots = [];

        List<double> weight = [];
        double i = 1;

        for (var element in meModel.madeApproachesChart!) {
          var date = meModel.selectDay.toString();
          String dateString = date.substring(0, date.length - 16);
          String elementDateSting =
              element.workoutDate.substring(0, element.workoutDate.length - 3);
          if (elementDateSting == dateString) {
            spots.add(FlSpot(i, double.parse(element.countList)));
            weight.add(double.parse(element.weight));
          }

          i++;
        }

        LineChartBarData barData = LineChartBarData(
          spots: spots,
          color: const Color.fromARGB(255, 208, 208, 208),
          barWidth: 4,
          isStrokeCapRound: true,
          isStrokeJoinRound: true,
          isCurved: true,
          curveSmoothness: 0.25,
          preventCurveOverShooting: true,
          preventCurveOvershootingThreshold: 1,
          showingIndicators: [0, 1, 2, 3, 4],
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              double minValue = double.infinity;
              double maxValue = double.negativeInfinity;

              for (var spot in weight) {
                if (spot < minValue) {
                  minValue = spot;
                }
                if (spot > maxValue) {
                  maxValue = spot;
                }
              }

              final value = weight[index];
              final percentage = (value - minValue) / (maxValue - minValue);

              const colorStart = Colors.blue;
              const colorEnd = Colors.red;

              final interpolatedColor =
                  Color.lerp(colorStart, colorEnd, percentage);
              return FlDotCirclePainter(
                radius: 4,
                color: interpolatedColor!,
              );
            },
            checkToShowDot: (spot, barData) {
              double minValue = double.infinity;
              double maxValue = double.negativeInfinity;
              for (var spot in spots) {
                if (spot.y < minValue) {
                  minValue = spot.y;
                }
                if (spot.y > maxValue) {
                  maxValue = spot.y;
                }
              }
              final value = spot.y;
              final shouldShowDot = value >= minValue && value <= maxValue;

              return shouldShowDot;
            },
          ),
        );
        LineChartData lineChartData = LineChartData(
          backgroundColor: kWhiteColor,
          lineBarsData: [barData],
          showingTooltipIndicators:
              (meModel.madeApproachesChart! != [] && spots == [])
                  ? [
                      for (int index in [2, 4])
                        ShowingTooltipIndicators(
                            [LineBarSpot(barData, index, spots[index])]),
                    ]
                  : [],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
              tooltipRoundedRadius: 10,
              tooltipHorizontalAlignment: FLHorizontalAlignment.left,
              tooltipPadding:
                  const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((LineBarSpot touchedSpot) {
                  final value = weight[touchedSpot.spotIndex];
                  return LineTooltipItem(
                    'Вес: $value',
                    const TextStyle(color: Colors.white),
                  );
                }).toList();
              },
            ),
            getTouchedSpotIndicator: (barData, touchSpotIndexes) {
              if (touchSpotIndexes.isEmpty) {
                return []; // Если не выбрано ни одной точки, то не отображаем индикаторы
              }
              selectedSpotIndex =
                  touchSpotIndexes.first; // Сохраняем индекс выбранной точки
              return [
                TouchedSpotIndicatorData(
                  const FlLine(
                      color: Color.fromARGB(255, 208, 208, 208),
                      strokeWidth: 2), // ВРЕМЕННОЕ РЕШЕНИЕ
                  FlDotData(
                    getDotPainter: (spot, percent, barData, index) {
                      double minValue = double.infinity;
                      double maxValue = double.negativeInfinity;

                      for (var spot in weight) {
                        if (spot < minValue) {
                          minValue = spot;
                        }
                        if (spot > maxValue) {
                          maxValue = spot;
                        }
                      }
                      final value = weight[index];
                      final percentage =
                          (value - minValue) / (maxValue - minValue);

                      const colorStart = Colors.blue;
                      const colorEnd = Colors.red;

                      final interpolatedColor =
                          Color.lerp(colorStart, colorEnd, percentage);
                      if (index == selectedSpotIndex) {
                        return FlDotCirclePainter(
                          radius: 6,
                          color: interpolatedColor!,
                        );
                      } else {
                        return FlDotCirclePainter(
                          radius: 0,
                          color: const Color.fromARGB(255, 208, 208, 208),
                          strokeColor: const Color.fromARGB(255, 208, 208, 208),
                          strokeWidth: 2,
                        );
                      }
                    },
                  ),
                ),
              ];
            },
          ),
          minX: 0,
          minY: 0,
          maxY: 35,
          titlesData: const FlTitlesData(
            show: true,
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: bottomTitleWidgets,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: leftTitleWidgets,
                reservedSize: 42,
              ),
            ),
          ),
          gridData: const FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: true,
            horizontalInterval: 10,
          ),
        );

        return LineChart(
          lineChartData,
        );
      },
    );
  }
}

Widget bottomTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 51, 51, 51),
    fontSize: 16,
  );
  int integer = value.toInt();
  Widget text = Text("$integer", style: style);

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}

Widget leftTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );
  String text;
  if (value.toInt() % 10 == 0 || value.toInt() % 5 == 0) {
    text = "${value.toInt()}";
  } else {
    text = '';
  }

  return Text(
    text,
    style: style,
    textAlign: TextAlign.left,
  );
}
