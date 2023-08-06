
import 'package:flutter/material.dart';
import 'package:front/data/data.dart';

class ModelTheme extends ChangeNotifier {
  late bool _isDark;
  late bool _isAuto;
  bool get isDark => _isDark;
  bool get isAuto => _isAuto;

  ModelTheme() {
    _isDark = false;
    getPreferences();
  }

  set isDark(bool value) {
    _isDark = value;
    Data.settings.isDarkMode = value;
    notifyListeners();
  }

  set isAuto(bool value) {
    _isAuto = value;
    Data.settings.isThemeModeAuto = value;
    notifyListeners();
  }

  getPreferences() async {
    _isDark = Data.settings.isDarkMode;
    _isAuto = Data.settings.isThemeModeAuto;
    notifyListeners();
  }
}