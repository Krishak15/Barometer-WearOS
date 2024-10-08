import 'package:barometer_app/screens/main_screen.dart';
import 'package:barometer_app/services/elevation/altitude_api.dart';
import 'package:barometer_app/services/broadcast/sensor_data.dart';
import 'package:barometer_app/services/weather/api/weather_api_services.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';


import 'permissions/location_permission.dart';
import 'permissions/sensors_permission.dart';

import 'services/reverse_geocoding/geocodingapi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestLocationPermission();
  await requestSensorAccessPermission();

  // LocationProvider coordinates = LocationProvider();
  // await coordinates.getCurrentLocation();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SensorDataProvider()),
        ChangeNotifierProvider(create: (_) => AltitudeApiProvider()),
        ChangeNotifierProvider(create: (_) => ReverseGeoCodingProvider()),
        ChangeNotifierProvider(create: (_) => WeatherApiService()),
        // ChangeNotifierProvider(create: (_) => LocationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

        title: 'Barometer',
        theme: ThemeData(
          visualDensity: VisualDensity.compact,

          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MainScreen()

        // MyPageView(
        //   pageController: _pageController,
        //   onPageChanged: (index) {
        //     _currentPageIndex = index;
        //   },
        // ),
        );
  }
}
