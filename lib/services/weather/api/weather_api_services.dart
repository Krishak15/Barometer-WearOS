import 'package:barometer_app/keys/api_keys.dart';
import 'package:barometer_app/services/weather/model/weather_data_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../location/location_service.dart';

class WeatherApiService extends ChangeNotifier {
  OpenWeatherDataModel? _openWeatherDataModel;
  OpenWeatherDataModel? get openWeatherDataModel => _openWeatherDataModel;

  Future<void> getWeatherData() async {
    LocationProvider coordinates = LocationProvider();
    await coordinates.getCurrentLocation();

    final lat = coordinates.latitude!.toStringAsFixed(6);
    final long = coordinates.longitude!.toStringAsFixed(6);

    final apiUrl = Uri(
      scheme: 'https',
      host: 'api.openweathermap.org',
      path: 'data/2.5/weather',
      queryParameters: {
        'lat': lat.toString(),
        'lon': long.toString(),
        'units': 'metric',
        'appid': openWeatherMapKey,
      },
    );

    
    final response = await http.get(apiUrl);

    try {
      if (response.statusCode == 200) {
        _openWeatherDataModel = openWeatherDataModelFromJson(response.body);
        if (kDebugMode) {
          print(response.body);
        }
        notifyListeners();
      }
    } on Exception catch (e) {
      rethrow;
    }
  }
}
