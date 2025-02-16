import 'package:barometer_app/services/weather/model/weather_data_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/weather_check_model.dart';
import '../services/weather/api/weather_api_services.dart';

mixin dataMixin {
  WeatherInfo checkWeatherMain(String main) {
    main = main
        .toLowerCase(); // Convert to lowercase for case-insensitive comparison

    if (main.contains('thunderstorm')) {
      return WeatherInfo('Thunderstorm', Colors.purple);
    } else if (main.contains('drizzle')) {
      return WeatherInfo('Drizzle', Colors.lightBlue);
    } else if (main.contains('rain')) {
      return WeatherInfo('Rain', Colors.blue);
    } else if (main.contains('snow')) {
      return WeatherInfo('Snow', Colors.white);
    } else if (main.contains('mist')) {
      return WeatherInfo('Mist', Colors.grey);
    } else if (main.contains('smoke')) {
      return WeatherInfo('Smoke', Colors.brown);
    } else if (main.contains('haze')) {
      return WeatherInfo('Haze', Colors.orange);
    } else if (main.contains('dust')) {
      return WeatherInfo('Dust', Colors.yellow);
    } else if (main.contains('fog')) {
      return WeatherInfo('Fog', Colors.grey);
    } else if (main.contains('sand')) {
      return WeatherInfo('Sand', Colors.yellowAccent);
    } else if (main.contains('ash')) {
      return WeatherInfo('Ash', Colors.grey);
    } else if (main.contains('squall')) {
      return WeatherInfo('Squall', Colors.lightBlueAccent);
    } else if (main.contains('tornado')) {
      return WeatherInfo('Tornado', Colors.red);
    } else if (main.contains('clear')) {
      return WeatherInfo('Clear', Colors.blueAccent);
    } else if (main.contains('clouds')) {
      return WeatherInfo('Clouds', Colors.grey);
    } else {
      return WeatherInfo('Unknown', Colors.black);
    }
  }

  Color changeWeatherTheme(context, WeatherApiService weatherProvider) {
    OpenWeatherDataModel? weatherData = weatherProvider.openWeatherDataModel;
    weatherData?.main.temp;

    if (weatherData != null) {
      final WeatherInfo weatherInfo =
          checkWeatherMain(weatherData.weather[0].main);

      return weatherInfo.color;
    } else {
      return Theme.of(context).colorScheme.primary;
    }
  }

}
