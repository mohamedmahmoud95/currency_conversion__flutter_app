/// Exchange rate entity representing conversion data between two currencies
class ExchangeRate {
  final String fromCurrency;
  final String toCurrency;
  final double rate;
  final DateTime timestamp;

  const ExchangeRate({
    required this.fromCurrency,
    required this.toCurrency,
    required this.rate,
    required this.timestamp,
  });

  double convertAmount(double amount) {
    return amount * rate;
  }

  double get reverseRate => 1.0 / rate;

  @override
  String toString() => '1 $fromCurrency = $rate $toCurrency';
}
