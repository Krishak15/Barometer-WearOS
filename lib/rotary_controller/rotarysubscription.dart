// Import the package.
import 'dart:async';

import 'package:wearable_rotary/wearable_rotary.dart';


StreamSubscription<RotaryEvent> rotarySubscription =
    rotaryEvents.listen((RotaryEvent event) {
  if (event.direction == RotaryDirection.clockwise) {
   //
  } else if (event.direction == RotaryDirection.counterClockwise) {
   //
  }
});


