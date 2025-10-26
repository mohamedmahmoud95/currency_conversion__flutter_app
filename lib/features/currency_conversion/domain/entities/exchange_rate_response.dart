
import 'package:lab_test_1/features/currency_conversion/domain/entities/exchange_rate.dart';

class ExchangeRateResponse {
  final bool success;
  final String? error;
  final ExchangeRate? data;

  const ExchangeRateResponse({
    required this.success,
    this.error,
    this.data,
  });

  factory ExchangeRateResponse.success(ExchangeRate data) {
    return ExchangeRateResponse(
      success: true,
      data: data,
    );
  }

  factory ExchangeRateResponse.error(String error) {
    return ExchangeRateResponse(
      success: false,
      error: error,
    );
  }
}
