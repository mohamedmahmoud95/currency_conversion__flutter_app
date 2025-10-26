import 'package:flutter/material.dart';
import '../../features/welcome_screen/presentation/view/page/welcome_screen.dart';
import '../../features/currency_conversion/presentation/view/page/currency_exchange_screen.dart';

class AppRouter {
  static const String welcome = '/';
  static const String currencyExchange = '/currency-exchange';
  
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
          settings: settings,
        );
      case currencyExchange:
        return MaterialPageRoute(
          builder: (_) => const CurrencyExchangeScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
          settings: settings,
        );
    }
  }
}
