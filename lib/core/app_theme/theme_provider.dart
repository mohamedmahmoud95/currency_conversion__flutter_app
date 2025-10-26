import 'package:flutter/material.dart';
import 'package:lab_test_1/core/services/theme_service.dart';

class ThemeProvider extends InheritedWidget {
  final ThemeService themeService;
  final VoidCallback toggleTheme;

  const ThemeProvider({
    super.key,
    required this.themeService,
    required this.toggleTheme,
    required super.child,
  });

  static ThemeProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeProvider>();
  }

  @override
  bool updateShouldNotify(ThemeProvider oldWidget) {
    return themeService != oldWidget.themeService;
  }
}