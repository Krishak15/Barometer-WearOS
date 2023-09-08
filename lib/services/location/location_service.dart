import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import 'location_permission.dart';

class LocationProvider with ChangeNotifier {
  double? latitude;
  double? longitude;

  Future<void> getCurrentLocation() async {
    if (kDebugMode) {
      print("loc called");
    }
    requestLocationPermission();

    try {
      if (kDebugMode) {
        print("try called");
      }

      Position position = await Geolocator.getCurrentPosition(
          forceAndroidLocationManager: true,
          desiredAccuracy: LocationAccuracy.medium);
      notifyListeners();

      // Stream<Position> position2 = Geolocator.getPositionStream(
      //     locationSettings: LocationSettings(accuracy: LocationAccuracy.high));
      if (kDebugMode) {
        print("position called");
      }
      latitude = position.latitude;
      longitude = position.longitude;

      if (kDebugMode) {
        print("what the F $latitude");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
