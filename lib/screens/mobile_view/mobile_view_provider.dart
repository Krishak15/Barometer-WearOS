import 'package:flutter/material.dart';

class MobileViewProvider extends ChangeNotifier {
  String? _pressureValue = "";
  String? get pressureData => _pressureValue;

  set pressureValue(String? value) {
    _pressureValue = value;
    notifyListeners();
  }
}
