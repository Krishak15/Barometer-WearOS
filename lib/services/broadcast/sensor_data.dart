import 'dart:async';

import 'package:environment_sensors/environment_sensors.dart';
import 'package:flutter/material.dart';


class SensorDataProvider with ChangeNotifier {
  EnvironmentSensors? environmentSensors;
  StreamSubscription<double>? _pressureStreamSubscription;
  double _latestPressure = 0.0;

  double get latestPressure => _latestPressure;

  Future<void> initPlatformState() async {
    environmentSensors = EnvironmentSensors();

    // Load initial data immediately
    _latestPressure = await environmentSensors!.pressure.first;
    notifyListeners();

    // Start updating at 2-minute intervals
    _pressureStreamSubscription = Stream.periodic(const Duration(seconds: 15))
        .asyncMap((_) => environmentSensors!.pressure.first)
        .listen((pressure) {
      
      _latestPressure = pressure;

      notifyListeners();
    });
  }

  @override
  void dispose() {
    _pressureStreamSubscription?.cancel();
    super.dispose();
  }
}



    // environmentSensors.pressure.listen((pressure) {

    // if (pressure > 999 && pressure < 1035) {
    //   setState(() {
    //     color = const Color.fromARGB(255, 255, 213, 0);
    //   });
    // } else if (pressure > 1035 && pressure < 1110) {
    //   setState(() {
    //     color = const Color.fromARGB(255, 255, 0, 0);
    //   });
    // } else if (pressure > 929 && pressure < 999) {
    //   setState(() {
    //     color = const Color.fromARGB(255, 82, 239, 47);
    //   });
    // } else if (pressure > 500 && pressure < 929) {
    //   setState(() {
    //     const Color.fromARGB(255, 255, 0, 0);
    //   });
    // } else {
    //   color = const Color.fromARGB(255, 82, 239, 47);
    // }
    //   });
