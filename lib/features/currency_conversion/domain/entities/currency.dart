/// Currency entity representing a currency with its code, name, and flag emoji
class Currency {
  final String code;
  final String name;
  final String flag;
  final String symbol;

  const Currency({
    required this.code,
    required this.name,
    required this.flag,
    required this.symbol,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Currency && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => '$flag $code - $name';
}

/// Default currencies for fallback scenarios
class DefaultCurrencies {
  static const List<Currency> fallbackCurrencies = [
    Currency(code: 'USD', name: 'US Dollar', flag: '🇺🇸', symbol: '\$'),
    Currency(code: 'EUR', name: 'Euro', flag: '🇪🇺', symbol: '€'),
    Currency(code: 'GBP', name: 'British Pound', flag: '🇬🇧', symbol: '£'),
    Currency(code: 'JPY', name: 'Japanese Yen', flag: '🇯🇵', symbol: '¥'),
    Currency(code: 'AUD', name: 'Australian Dollar', flag: '🇦🇺', symbol: 'A\$'),
    Currency(code: 'CAD', name: 'Canadian Dollar', flag: '🇨🇦', symbol: 'C\$'),
    Currency(code: 'CHF', name: 'Swiss Franc', flag: '🇨🇭', symbol: 'CHF'),
    Currency(code: 'CNY', name: 'Chinese Yuan', flag: '🇨🇳', symbol: '¥'),
    Currency(code: 'INR', name: 'Indian Rupee', flag: '🇮🇳', symbol: '₹'),
    Currency(code: 'BRL', name: 'Brazilian Real', flag: '🇧🇷', symbol: 'R\$'),
    Currency(code: 'RUB', name: 'Russian Ruble', flag: '🇷🇺', symbol: '₽'),
    Currency(code: 'KRW', name: 'South Korean Won', flag: '🇰🇷', symbol: '₩'),
    Currency(code: 'MXN', name: 'Mexican Peso', flag: '🇲🇽', symbol: '\$'),
    Currency(code: 'SGD', name: 'Singapore Dollar', flag: '🇸🇬', symbol: 'S\$'),
    Currency(code: 'HKD', name: 'Hong Kong Dollar', flag: '🇭🇰', symbol: 'HK\$'),
    Currency(code: 'NZD', name: 'New Zealand Dollar', flag: '🇳🇿', symbol: 'NZ\$'),
    Currency(code: 'NOK', name: 'Norwegian Krone', flag: '🇳🇴', symbol: 'kr'),
    Currency(code: 'SEK', name: 'Swedish Krona', flag: '🇸🇪', symbol: 'kr'),
    Currency(code: 'DKK', name: 'Danish Krone', flag: '🇩🇰', symbol: 'kr'),
    Currency(code: 'PLN', name: 'Polish Zloty', flag: '🇵🇱', symbol: 'zł'),
    Currency(code: 'TRY', name: 'Turkish Lira', flag: '🇹🇷', symbol: '₺'),
    Currency(code: 'ZAR', name: 'South African Rand', flag: '🇿🇦', symbol: 'R'),
    Currency(code: 'EGP', name: 'Egyptian Pound', flag: '🇪🇬', symbol: '£'),
    Currency(code: 'NGN', name: 'Nigerian Naira', flag: '🇳🇬', symbol: '₦'),
    Currency(code: 'GHS', name: 'Ghanaian Cedi', flag: '🇬🇭', symbol: '₵'),
  ];
}