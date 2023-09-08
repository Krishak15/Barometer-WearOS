import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// class AltitudeApiProvider with ChangeNotifier {
//   Map<String, dynamic> altitude = {};
//   double altitudeString = 0;
//   double get elevation => altitudeString;
//   bool isLoading = true;

//   Future<void> fetchAltitudeData(BuildContext context) async {
//     isLoading = true;

//     Provider.of<FirebaseDataProvider>(context, listen: false).fetchData();

//     final firebaseDataProvider = Provider.of<FirebaseDataProvider>(context);
//     firebaseDataProvider.fetchData();
//     String lat = firebaseDataProvider.latitude.toStringAsFixed(2);
//     String long = firebaseDataProvider.longitude.toStringAsFixed(2);

//     print("---------------------${firebaseDataProvider.latitude}");

//     LocationProvider coordinates = LocationProvider();
//     await coordinates.getCurrentLocation();

//     final coordinatesval =
//         'latitude=${coordinates.latitude!.toStringAsFixed(2)}&longitude=${coordinates.longitude!.toStringAsFixed(2)}';
//     // print(coordinatesval);
//     final url =
//         Uri.parse("https://api.open-meteo.com/v1/elevation?$coordinatesval");

//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final altitudeData = jsonDecode(response.body);

//       altitudeString = altitudeData['elevation'][0];
//       isLoading = false;

//       notifyListeners();
//     }
//   }
// }

class AltitudeApiProvider with ChangeNotifier {
  Map<String, dynamic> altitude = {};
  double altitudeString = 0;
  double get elevation => altitudeString;
  bool isLoading = true;

  Future<void> fetchAltitudeData(
      BuildContext context, latitude, longitude) async {
    final coordinatesval = 'latitude=$latitude&longitude=$longitude';
    final url =
        Uri.parse("https://api.open-meteo.com/v1/elevation?$coordinatesval");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      print("Elevation Fetched");
      isLoading = true;
      notifyListeners();
      final altitudeData = jsonDecode(response.body);

      altitudeString = altitudeData['elevation'][0];

      isLoading = false;

      notifyListeners();
    }
  }
}
