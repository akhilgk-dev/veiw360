import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeChart extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  HomeChart({Key? key}) : super(key: key);

  @override
  HomeChartState createState() => HomeChartState();
}

class HomeChartState extends State<HomeChart> {
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    data = [
      _ChartData('Active', 25, Colors.blue),
      _ChartData('Upcoming', 38, Colors.green),
      _ChartData('Previous', 34, Colors.pink),
      _ChartData('Special', 52, Colors.deepPurple),
    ];
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      tooltipBehavior: _tooltip,
      legend: Legend(
        position: LegendPosition.bottom,
        isVisible: true,
        alignment: ChartAlignment.center,
        textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      series: <CircularSeries<_ChartData, String>>[
        DoughnutSeries<_ChartData, String>(
          dataSource: data,
          xValueMapper: (_ChartData data, _) => data.x,
          yValueMapper: (_ChartData data, _) => data.y,
          name: 'Gold',
          explode: true,
          explodeIndex: 1,
          pointColorMapper: (datum, index) => datum.clr,
        ),
      ],
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y, this.clr);

  final String x;
  final double y;
  final Color clr;
}
