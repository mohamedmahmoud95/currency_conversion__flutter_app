import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lab_test_1/features/currency_conversion/domain/entities/exchange_rate_response.dart';
import '../../domain/entities/exchange_rate.dart';

class CurrencyApiService {
  static const String _baseUrl = 'https://api.exchangerate.host';
  static const String _frankfurterUrl = 'https://api.frankfurter.app';

  Future<ExchangeRateResponse> _getExchangeRateFromPrimary({
    required String fromCurrency,
    required String toCurrency,
  }) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/convert?from=$fromCurrency&to=$toCurrency&amount=1',
      );
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['success'] == true && data['result'] != null) {
          final rate = double.parse(data['result'].toString());
          return ExchangeRateResponse.success(
            ExchangeRate(
              fromCurrency: fromCurrency,
              toCurrency: toCurrency,
              rate: rate,
              timestamp: DateTime.now(),
            ),
          );
        } else {
          return ExchangeRateResponse.error(
            data['error']?['info'] ?? 'Failed to fetch exchange rate',
          );
        }
      } else {
        return ExchangeRateResponse.error(
          'HTTP Error: ${response.statusCode}',
        );
      }
    } catch (e) {
      return ExchangeRateResponse.error('Network error: $e');
    }
  }

  // in case the primary API is not available, we use the fallback API
  Future<ExchangeRateResponse> _getExchangeRateFromFallback({
    required String fromCurrency,
    required String toCurrency,
  }) async {
    try {
      final url = Uri.parse(
        '$_frankfurterUrl/latest?from=$fromCurrency&to=$toCurrency',
      );
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['rates'] != null && data['rates'][toCurrency] != null) {
          final rate = double.parse(data['rates'][toCurrency].toString());
          return ExchangeRateResponse.success(
            ExchangeRate(
              fromCurrency: fromCurrency,
              toCurrency: toCurrency,
              rate: rate,
              timestamp: DateTime.now(),
            ),
          );
        } else {
          return ExchangeRateResponse.error('Currency not supported');
        }
      } else {
        return ExchangeRateResponse.error(
          'HTTP Error: ${response.statusCode}',
        );
      }
    } catch (e) {
      return ExchangeRateResponse.error('Network error: $e');
    }
  }

  /// Get exchange rate with fallback mechanism
  Future<ExchangeRateResponse> getExchangeRate({
    required String fromCurrency,
    required String toCurrency,
  }) async {
    // Try primary API first
    final primaryResponse = await _getExchangeRateFromPrimary(
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
    );
    
    if (primaryResponse.success) {
      return primaryResponse;
    }
    
    // If primary fails, try fallback API
    return await _getExchangeRateFromFallback(
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
    );
  }

  Future<Map<String, String>> getSupportedCurrencies() async {
    try {
      final url = Uri.parse('$_baseUrl/symbols');
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['success'] == true && data['symbols'] != null) {
          return Map<String, String>.from(data['symbols']);
        }
      }
    } catch (e) {
      // Fallback to hardcoded list
    }
    
    // Fallback to a hardcoded list of common currencies 
    return {
      'USD': 'US Dollar',
      'EUR': 'Euro',
      'GBP': 'British Pound Sterling',
      'JPY': 'Japanese Yen',
      'AUD': 'Australian Dollar',
      'CAD': 'Canadian Dollar',
      'CHF': 'Swiss Franc',
      'CNY': 'Chinese Yuan',
      'INR': 'Indian Rupee',
      'BRL': 'Brazilian Real',
      'KRW': 'South Korean Won',
      'MXN': 'Mexican Peso',
      'SGD': 'Singapore Dollar',
      'HKD': 'Hong Kong Dollar',
      'NOK': 'Norwegian Krone',
      'SEK': 'Swedish Krona',
      'DKK': 'Danish Krone',
      'PLN': 'Polish Zloty',
      'RUB': 'Russian Ruble',
      'ZAR': 'South African Rand',
      'TRY': 'Turkish Lira',
      'AED': 'UAE Dirham',
      'SAR': 'Saudi Riyal',
      'EGP': 'Egyptian Pound',
    };
  }
}
