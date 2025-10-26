import 'package:lab_test_1/features/currency_conversion/domain/entities/exchange_rate_response.dart';
import '../../domain/repositories/currency_repository.dart';
import '../datasources/currency_api_service.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyApiService _apiService;

  const CurrencyRepositoryImpl({
    required CurrencyApiService apiService,
  }) : _apiService = apiService;

  @override
  Future<ExchangeRateResponse> getExchangeRate({
    required String fromCurrency,
    required String toCurrency,
  }) async {
    return await _apiService.getExchangeRate(
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
    );
  }

  @override
  Future<Map<String, String>> getSupportedCurrencies() async {
    return await _apiService.getSupportedCurrencies();
  }
}