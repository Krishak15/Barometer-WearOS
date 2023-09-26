import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AltitudeApiProvider with ChangeNotifier {
  Map<String, dynamic> altitude = {};
  double altitudeString = 0;
  double get elevation => altitudeString;
  bool isLoading = true;

  Future<void> fetchAltitudeData(
      BuildContext context, latitude, longitude) async {
    final coordinatesval = '$latitude,$longitude';
    final url = Uri.parse(
        "https://api.open-elevation.com/api/v1/lookup?locations=$coordinatesval");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("Elevation Fetched");
      }
      isLoading = true;
      notifyListeners();
      if (kDebugMode) {
        print(response.body);
      }
      final altitudeData = jsonDecode(response.body);

      altitudeString = altitudeData['results'][0]['elevation'];
      if (kDebugMode) {
        print(altitudeString);
      }

      isLoading = false;

      notifyListeners();
    }
  }
}
