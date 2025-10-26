import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static ThemeService? _instance;
  late SharedPreferences _preferences;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeService._(); 

  static Future<ThemeService> getInstance() async {
    if (_instance == null) {
      _instance = ThemeService._();
      await _instance!._init();
    }
    return _instance!;
  }

  Future<void> _init() async {
    _preferences = await SharedPreferences.getInstance();
    _loadThemeFromPreferences();
  }

  void _loadThemeFromPreferences() {
    final themeIndex = _preferences.getInt('themeMode');
    if (themeIndex != null) {
      _themeMode = ThemeMode.values[themeIndex];
    } else {
      _themeMode = ThemeMode.system; 
    }
  }

  Future<ThemeMode> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    await _preferences.setInt('themeMode', _themeMode.index);
    return _themeMode;
  }
}
