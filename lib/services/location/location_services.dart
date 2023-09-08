// import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
//     as bg;

// class LocationService {
//   double? latitude;
//   double? longitude;
//   LocationService() {
//     // Initialize background geolocation.
//     bg.BackgroundGeolocation.onLocation((bg.Location location) {
//       latitude = location.coords.latitude;
//       longitude = location.coords.longitude;

//       print("LATITUDE _ $latitude");
//       // Handle location updates here.
//       // You can store the location data in a variable or stream for access in other classes.
//     });

//     bg.BackgroundGeolocation.start();
//   }

//   // Add methods to start and stop location updates if needed.
//   void startLocationUpdates() {
//     bg.BackgroundGeolocation.start();
//   }

//   void stopLocationUpdates() {
//     bg.BackgroundGeolocation.stop();
//   }
// }
