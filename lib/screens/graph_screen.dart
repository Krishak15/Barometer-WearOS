import 'package:barometer_app/chart/atm_chart.dart';
import 'package:flutter/material.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key});

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          child: Center(child: LineChartSample2())),
    );
  }
}
