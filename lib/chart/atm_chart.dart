import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/broadcast/sensor_data.dart';

class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({super.key});

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<FlSpot> spotsData = [];
  double dx = 0;
  List<Color> gradientColors = const [
    Color.fromARGB(255, 0, 251, 255),
    Color.fromARGB(255, 0, 255, 136),
  ];
  int maxDataPoints = 100; // Set the maximum number of data points to keep
  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.1,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 12,
                left: 10,
                top: 24,
                bottom: 12,
              ),
              child: AspectRatio(
                aspectRatio: 1.1,
                child: LineChart(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.bounceIn,
                  mainData(),
                ),
              ),
            ),
          ),
          // SizedBox(
          //   width: 60,
          //   height: 34,
          //   child: TextButton(
          //     onPressed: () {
          //       setState(() {
          //         showAvg = !showAvg;
          //       });
          //     },
          //     child: Text(
          //       'Alt',
          //       style: TextStyle(
          //         fontSize: 12,
          //         color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
        fontWeight: FontWeight.w300, fontSize: 10, color: Colors.white);
    Widget text;
    switch (value.toInt()) {
      case 10:
        text = const Text('1 Hour', style: style);
        break;

      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
        fontWeight: FontWeight.w300,
        fontSize: 6,
        color: Color.fromARGB(255, 238, 255, 0));
    String text;
    switch (value.toInt()) {
      case 1100:
        text = '1100';
      case 1000:
        text = '1000';
        break;
      case 900:
        text = '900';
        break;
      case 800:
        text = '800';
      case 600:
        text = '600';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  // Widget leftTitleWidgets(double value, TitleMeta meta) {
  //   final pressureData = Provider.of<SensorDataProvider>(context, listen: true);
  //   const style = TextStyle(
  //       fontWeight: FontWeight.w100, fontSize: 10, color: Colors.white);
  //   String text;
  //   //switch case was here
  //   // if (pressureData.latestPressure > 999 &&
  //   //     pressureData.latestPressure < 1100) {
  //   //   text = '1000';
  //   // } else if (pressureData.latestPressure < 999 &&
  //   //     pressureData.latestPressure > 900) {
  //   //   text = '900';
  //   // } else {
  //   //   text = "";
  //   // }

  //   switch (value.toInt()) {
  //     case 1:
  //       text = '10K';
  //       break;
  //     case 3:
  //       text = '30k';
  //       break;
  //     case 5:
  //       text = '50k';
  //       break;
  //     default:
  //       return Container();
  //   }

  //   // switch (pressureData.latestPressure.toInt()) {
  //   //   case 900:
  //   //   case 901:
  //   //     // Add more cases as needed for values between 900 and 999.
  //   //     // For example, case 902:, case 903:, ..., case 998:
  //   //     text = "900";
  //   //     break;
  //   //   case 999:
  //   //   case 1000:
  //   //     // Add more cases as needed for values between 999 and 1100.
  //   //     // For example, case 1001:, case 1002:, ..., case 1099:
  //   //     text = "1000";
  //   //     break;
  //   //   default:
  //   //     text = "";
  //   //     break;
  //   // }

  //   return Text(text, style: style, textAlign: TextAlign.left);
  // }

  LineChartData mainData() {
    final pressureData =
        Provider.of<SensorDataProvider>(context, listen: true).latestPressure;
    dx++;

    if (spotsData.length >= maxDataPoints) {
      spotsData.removeAt(0); // Remove the oldest data point
    }

    // double clippedPressure = pressureData.clamp(600, 1100);

    spotsData.add(FlSpot(dx, pressureData));

    if (kDebugMode) {
      print("-----------------------${spotsData.length}");
    }

    return LineChartData(
      clipData:
          const FlClipData(bottom: true, left: true, top: true, right: true),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        drawVerticalLine: false,
        horizontalInterval: 90,
        verticalInterval: 2,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color.fromARGB(255, 59, 58, 58),
            strokeWidth: 0.4,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color.fromARGB(255, 59, 58, 58),
            strokeWidth: 0.0,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
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
            reservedSize: 30,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: dx > maxDataPoints ? dx - maxDataPoints : 0,
      maxX: dx,
      minY: 800,
      maxY: 1100,
      lineBarsData: [
        LineChartBarData(
          spots: spotsData,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 2,
          curveSmoothness: 0.65,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            applyCutOffY: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

//   LineChartData avgData() {
//     return LineChartData(
//       lineTouchData: const LineTouchData(enabled: false),
//       gridData: FlGridData(
//         show: true,
//         drawHorizontalLine: true,
//         verticalInterval: 1,
//         horizontalInterval: 1,
//         getDrawingVerticalLine: (value) {
//           return const FlLine(
//             color: Color(0xff37434d),
//             strokeWidth: 1,
//           );
//         },
//         getDrawingHorizontalLine: (value) {
//           return const FlLine(
//             color: Color(0xff37434d),
//             strokeWidth: 1,
//           );
//         },
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             reservedSize: 30,
//             getTitlesWidget: bottomTitleWidgets,
//             interval: 1,
//           ),
//         ),
//         leftTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             getTitlesWidget: leftTitleWidgets,
//             reservedSize: 42,
//             interval: 1,
//           ),
//         ),
//         topTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         rightTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//       ),
//       borderData: FlBorderData(
//         show: true,
//         border: Border.all(color: const Color(0xff37434d)),
//       ),
//       minX: 0,
//       maxX: 30,
//       minY: 600,
//       maxY: 1100,
//       lineBarsData: [
//         LineChartBarData(
//           spots: spotsData,
//           isCurved: true,
//           gradient: LinearGradient(
//             colors: [
//               ColorTween(begin: gradientColors[0], end: gradientColors[1])
//                   .lerp(0.2)!,
//               ColorTween(begin: gradientColors[0], end: gradientColors[1])
//                   .lerp(0.2)!,
//             ],
//           ),
//           barWidth: 5,
//           isStrokeCapRound: true,
//           dotData: const FlDotData(
//             show: false,
//           ),
//           belowBarData: BarAreaData(
//             show: true,
//             gradient: LinearGradient(
//               colors: [
//                 ColorTween(begin: gradientColors[0], end: gradientColors[1])
//                     .lerp(0.2)!
//                     .withOpacity(0.1),
//                 ColorTween(begin: gradientColors[0], end: gradientColors[1])
//                     .lerp(0.2)!
//                     .withOpacity(0.1),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
}
