import 'package:barometer_app/services/reverse_geocoding/geocode_api_key.dart';
import 'package:barometer_app/services/reverse_geocoding/revgeocoding_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../elevation/altitude_api.dart';
import '../location/location_service.dart';

class ReverseGeoCodingProvider with ChangeNotifier {
  ReverseGeoGeocodingModel? _reverseGeoModel;
  ReverseGeoGeocodingModel? get reverseGeoModel => _reverseGeoModel;
  bool isLoading = true;

  Future<void> fetchApiData(ctx) async {
    if (kDebugMode) {
      print("Location revgeo");
    }
    isLoading = true;

    LocationProvider coordinates = LocationProvider();
    await coordinates.getCurrentLocation();

    if (kDebugMode) {
      print("Location fetched");
    }

    final coordinatesval =
        'lat=${coordinates.latitude!.toStringAsFixed(6)}&lon=${coordinates.longitude!.toStringAsFixed(6)}';

    if (kDebugMode) {
      print(coordinatesval);
    }

    final latt = coordinates.latitude!.toStringAsFixed(6);
    final long = coordinates.longitude!.toStringAsFixed(6);

    final url = Uri.parse(
        "https://eu1.locationiq.com/v1/reverse?key=$API_TOKEN&$coordinatesval&format=json");

    final response = await http.get(url);

    try {
      if (response.statusCode == 200) {
        _reverseGeoModel = reverseGeoGeocodingModelFromJson(response.body);
        if (kDebugMode) {
          print(response.body);
        }
        Provider.of<AltitudeApiProvider>(ctx, listen: false)
            .fetchAltitudeData(ctx, latt, long);
        isLoading = false;
        notifyListeners();
      } else {
        if (kDebugMode) {
          print("Failed to load Rev GEO API");
        }
        throw Exception("Failed to load reverse geocoding data");
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
