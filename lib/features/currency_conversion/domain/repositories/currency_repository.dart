import 'package:lab_test_1/features/currency_conversion/domain/entities/exchange_rate_response.dart';

/// Repository interface for currency operations
abstract class CurrencyRepository {
  Future<ExchangeRateResponse> getExchangeRate({
    required String fromCurrency,
    required String toCurrency,
  });

  Future<Map<String, String>> getSupportedCurrencies();
}
