import 'package:permission_handler/permission_handler.dart';

Future<void> requestLocationPermission() async {
  var status = await Permission.location.request();

  if (status.isGranted) {
    // Permission granted, can access the location now
  } else if (status.isDenied) {
    // Permission denied
  } else if (status.isPermanentlyDenied) {
    // Permission permanently denied, open app settings
    openAppSettings();
  }
}
