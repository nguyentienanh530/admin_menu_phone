import 'package:admin_menu_mobile/core/utils/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartRevenue extends StatefulWidget {
  const ChartRevenue({super.key});

  @override
  State<ChartRevenue> createState() => _ChartRevenueState();
}

class _ChartRevenueState extends State<ChartRevenue> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: LineChart(sampleData1,
            duration: const Duration(milliseconds: 250)));
  }

  LineChartData get sampleData1 => LineChartData(
      // lineTouchData: lineTouchData1,
      gridData: gridData,
      titlesData: titlesData1,
      borderData: borderData,
      lineBarsData: lineBarsData1,
      // minX: 0.5,
      // maxX: 14,
      // maxY: 4,
      minY: 0);

  LineTouchData get lineTouchData1 => LineTouchData(
      handleBuiltInTouches: true,
      touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8)));

  FlTitlesData get titlesData1 => FlTitlesData(
      bottomTitles: AxisTitles(sideTitles: bottomTitles),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(sideTitles: leftTitles()));

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
      ];

  LineTouchData get lineTouchData2 => const LineTouchData(
        enabled: false,
      );

  FlTitlesData get titlesData2 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '1m';
        break;
      case 2:
        text = '2m';
        break;
      case 3:
        text = '3m';
        break;
      case 4:
        text = '5m';
        break;
      case 5:
        text = '6m';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => const SideTitles(
        // getTitlesWidget: leftTitleWidgets,
        // showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('SEPT', style: style);
        break;
      case 7:
        text = const Text('OCT', style: style);
        break;
      case 12:
        text = const Text('DEC', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => const SideTitles(
        showTitles: false,
        reservedSize: 32,
        interval: 1,
        // getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
      show: true,
      border: const Border(
          // bottom: BorderSide(color: Colors.red, width: 4),
          // left: const BorderSide(color: Colors.transparent),
          // right: const BorderSide(color: Colors.transparent),
          // top: const BorderSide(color: Colors.transparent),
          ));

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
          isCurved: true,
          color: context.colorScheme.secondary,
          barWidth: 2,
          isStrokeCapRound: true,
          curveSmoothness: 0.4,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                // end: const Alignment(0.8, 1),
                colors: <Color>[
                  context.colorScheme.secondary.withOpacity(0.1),
                  context.colorScheme.secondary.withOpacity(0.3),
                  context.colorScheme.secondary.withOpacity(0.6)
                ],
                tileMode: TileMode.mirror,
              )),
          spots: const [
            FlSpot(0, 0),
            FlSpot(1, 1.5),
            FlSpot(2, 1.4),
            FlSpot(3, 3.4),
            FlSpot(4, 4.5),
            FlSpot(5, 2),
            FlSpot(6, 2.2),
            FlSpot(7, 1.8),
            FlSpot(8, 4)
          ]);
}
