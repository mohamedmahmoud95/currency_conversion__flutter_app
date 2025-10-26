
import 'package:flutter/material.dart';
import 'package:lab_test_1/core/app_router/app_router.dart';
import 'package:lab_test_1/core/app_theme/app_theme.dart';
import 'package:lab_test_1/core/app_theme/theme_provider.dart';
import 'package:lab_test_1/core/services/theme_service.dart';

class CurrencyConverterApp extends StatefulWidget {
  const CurrencyConverterApp({super.key});

  @override
  State<CurrencyConverterApp> createState() => _CurrencyConverterAppState();
}

class _CurrencyConverterAppState extends State<CurrencyConverterApp> {
  ThemeService? _themeService;
  ThemeMode _currentTheme = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _initializeTheme();
  }

  Future<void> _initializeTheme() async {
    _themeService = await ThemeService.getInstance();
    if (mounted) {
      setState(() {
        _currentTheme = _themeService!.themeMode;
      });
    }
  }

  void _toggleTheme() async {
    if (_themeService != null) {
      final newTheme = await _themeService!.toggleTheme();
      if (mounted) {
        setState(() {
          _currentTheme = newTheme;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _currentTheme,
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: AppRouter.welcome,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return ThemeProvider(
          themeService: _themeService!,
          toggleTheme: _toggleTheme,
          child: child!,
        );
      },
    );
  }
}