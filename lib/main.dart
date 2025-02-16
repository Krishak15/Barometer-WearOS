import 'dart:ffi';
import 'dart:io';

import 'package:barometer_app/extensions/custome_extensions.dart';
import 'package:barometer_app/screens/main_screen.dart';
import 'package:barometer_app/screens/mobile_view/main_screen_mobile.dart';
import 'package:barometer_app/screens/mobile_view/mobile_view_provider.dart';
import 'package:barometer_app/services/elevation/altitude_api.dart';
import 'package:barometer_app/services/broadcast/sensor_data.dart';
import 'package:barometer_app/services/weather/api/weather_api_services.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'permissions/location_permission.dart';
import 'permissions/sensors_permission.dart';

import 'services/reverse_geocoding/geocodingapi.dart';

Future<bool> isWearOS() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    // androidInfo.log("androidInfo");
    // Check for the presence of 'wear' in the system features
    if (androidInfo.systemFeatures.contains('android.hardware.type.watch')) {
      return true; // This device is running Wear OS
    }
  }
  return false; // Not a Wear OS device
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestLocationPermission();

  bool isWearable = await isWearOS();
  if (isWearable) await requestSensorAccessPermission();

  // LocationProvider coordinates = LocationProvider();
  // await coordinates.getCurrentLocation();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SensorDataProvider()),
        ChangeNotifierProvider(create: (_) => AltitudeApiProvider()),
        ChangeNotifierProvider(create: (_) => ReverseGeoCodingProvider()),
        ChangeNotifierProvider(create: (_) => WeatherApiService()),
        ChangeNotifierProvider(create: (_) => MobileViewProvider()),
      ],
      child: isWearable ? const MyApp() : const MyAppMobile(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

class MyAppMobile extends StatelessWidget {
  const MyAppMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Barometer',
        theme: ThemeData(
          visualDensity: VisualDensity.compact,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MainScreenMobile());
  }
}
