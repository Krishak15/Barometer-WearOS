import 'package:flutter/foundation.dart';

void colorPrint(String msg, {EnumLogColor? color}) {
  try {
    // 'bold': '\x1B[1m',
    String coloredMessage = '\x1B[34m';
    switch (color) {
      case EnumLogColor.red:
        coloredMessage = '\x1B[31m';
        break;
      case EnumLogColor.green:
        coloredMessage = '\x1B[32m';
        break;
      case EnumLogColor.blue:
        coloredMessage = '\x1B[34m';
        break;
      case EnumLogColor.yellow:
        coloredMessage = '\x1B[33m';
        break;
      default:
        coloredMessage = '\x1B[33m';
        break;
    }
    const String resetColor = '\x1B[0m';

    if (kDebugMode) {
      print('$coloredMessage $msg $resetColor');
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}

enum EnumLogColor { red, green, blue, yellow }

extension Logger<E> on E {
  E log([String key = '', EnumLogColor? color]) {
    colorPrint("::: $key : $this", color: color ?? EnumLogColor.yellow);
    return this;
  }
}


