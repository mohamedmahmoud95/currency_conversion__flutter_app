import '../entities/currency.dart';
import '../repositories/currency_repository.dart';

/// Service for managing currency data with caching
class CurrencyService {
  final CurrencyRepository _repository;
  List<Currency>? _cachedCurrencies;
  DateTime? _lastFetchTime;
  static const Duration _cacheExpiry = Duration(hours: 24);

  CurrencyService({required CurrencyRepository repository}) 
      : _repository = repository;

  Future<List<Currency>> getSupportedCurrencies() async {
    // Return cached data if still valid
    if (_cachedCurrencies != null && 
        _lastFetchTime != null && 
        DateTime.now().difference(_lastFetchTime!) < _cacheExpiry) {
      return _cachedCurrencies!;
    }

    try {
      final currencyMap = await _repository.getSupportedCurrencies();
      
      // Convert to Currency objects with flags and symbols
      _cachedCurrencies = currencyMap.entries.map((entry) {
        return Currency(
          code: entry.key,
          name: entry.value,
          flag: _getFlagForCurrency(entry.key),
          symbol: _getSymbolForCurrency(entry.key),
        );
      }).toList();

      _lastFetchTime = DateTime.now();
      return _cachedCurrencies!;
    } catch (e) {
      return _getFallbackCurrencies();
    }
  }

  Future<Currency?> getCurrencyByCode(String code) async {
    final currencies = await getSupportedCurrencies();
    try {
      return currencies.firstWhere((currency) => currency.code == code);
    } catch (e) {
      return null;
    }
  }

  /// In case API fails
  List<Currency> _getFallbackCurrencies() {
    return const [
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

  String _getSymbolForCurrency(String currencyCode) {
    const symbolMap = {
      'USD': '\$', 'EUR': '€', 'GBP': '£', 'JPY': '¥',
      'AUD': 'A\$', 'CAD': 'C\$', 'CHF': 'CHF', 'CNY': '¥',
      'INR': '₹', 'BRL': 'R\$', 'RUB': '₽', 'KRW': '₩',
      'MXN': '\$', 'SGD': 'S\$', 'HKD': 'HK\$', 'NZD': 'NZ\$',
      'NOK': 'kr', 'SEK': 'kr', 'DKK': 'kr', 'PLN': 'zł',
      'TRY': '₺', 'ZAR': 'R', 'EGP': '£', 'NGN': '₦',
      'GHS': '₵', 'AED': 'د.إ', 'SAR': '﷼', 'QAR': '﷼',
      'KWD': 'د.ك', 'BHD': 'د.ب', 'OMR': '﷼', 'JOD': 'د.ا',
      'LBP': 'ل.ل', 'ILS': '₪', 'THB': '฿', 'VND': '₫',
      'IDR': 'Rp', 'MYR': 'RM', 'PHP': '₱', 'TWD': 'NT\$',
      'HUF': 'Ft', 'CZK': 'Kč', 'RON': 'lei', 'BGN': 'лв',
      'HRK': 'kn', 'RSD': 'дин', 'UAH': '₴', 'BYN': 'Br',
      'KZT': '₸', 'UZS': 'лв', 'KGS': 'лв', 'TJS': 'SM',
      'TMT': 'T', 'AFN': '؋', 'PKR': '₨', 'LKR': '₨',
      'BDT': '৳', 'NPR': '₨', 'BTN': 'Nu', 'MMK': 'K',
      'LAK': '₭', 'KHR': '៛', 'MOP': 'MOP\$', 'BND': 'B\$',
      'FJD': 'FJ\$', 'PGK': 'K', 'SBD': 'SI\$', 'VUV': 'Vt',
      'WST': 'WS\$', 'TOP': 'T\$', 'XPF': '₣', 'MVR': 'ރ',
      'SCR': '₨', 'KMF': 'CF', 'DJF': 'Fdj', 'ETB': 'Br',
      'KES': 'KSh', 'TZS': 'TSh', 'UGX': 'USh', 'RWF': 'RF',
      'BIF': 'FBu', 'MWK': 'MK', 'ZMW': 'ZK', 'BWP': 'P',
      'SZL': 'L', 'LSL': 'L', 'NAD': 'N\$', 'AOA': 'Kz',
      'MZN': 'MT', 'MGA': 'Ar', 'MUR': '₨', 'SLL': 'Le',
      'GMD': 'D', 'GNF': 'FG', 'LRD': 'L\$', 'CDF': 'FC',
      'XAF': 'FCFA', 'XOF': 'CFA', 'MAD': 'د.م', 'DZD': 'د.ج',
      'TND': 'د.ت', 'LYD': 'ل.د', 'SDG': 'ج.س', 'SSP': '£',
      'ERN': 'Nfk', 'SOS': 'S', 'ARS': '\$', 'CLP': '\$',
      'COP': '\$', 'PEN': 'S/', 'UYU': '\$U', 'VES': 'Bs',
      'GYD': 'G\$', 'SRD': '\$', 'TTD': 'TT\$', 'BBD': 'Bds\$',
      'JMD': 'J\$', 'BZD': 'BZ\$', 'GTQ': 'Q', 'HNL': 'L',
      'NIO': 'C\$', 'CRC': '₡', 'PAB': 'B/.', 'DOP': 'RD\$',
      'HTG': 'G', 'CUP': '\$', 'XCD': 'EC\$', 'AWG': 'ƒ',
      'BMD': 'BD\$', 'KYD': 'CI\$', 'SHP': '£', 'FKP': '£',
      'MDL': 'L', 'MKD': 'ден', 'ALL': 'L', 'BAM': 'КМ',
      'SKK': 'Sk', 'ISK': 'kr',
    };
    
    return symbolMap[currencyCode] ?? currencyCode;
  }

  /// Get flag emoji for currency code
  String _getFlagForCurrency(String currencyCode) {
    const flagMap = {
      'USD': '🇺🇸', 'EUR': '🇪🇺', 'GBP': '🇬🇧', 'JPY': '🇯🇵',
      'AUD': '🇦🇺', 'CAD': '🇨🇦', 'CHF': '🇨🇭', 'CNY': '🇨🇳',
      'INR': '🇮🇳', 'BRL': '🇧🇷', 'RUB': '🇷🇺', 'KRW': '🇰🇷',
      'MXN': '🇲🇽', 'SGD': '🇸🇬', 'HKD': '🇭🇰', 'NZD': '🇳🇿',
      'NOK': '🇳🇴', 'SEK': '🇸🇪', 'DKK': '🇩🇰', 'PLN': '🇵🇱',
      'TRY': '🇹🇷', 'ZAR': '🇿🇦', 'EGP': '🇪🇬', 'NGN': '🇳🇬',
      'GHS': '🇬🇭', 'AED': '🇦🇪', 'SAR': '🇸🇦', 'QAR': '🇶🇦',
      'KWD': '🇰🇼', 'BHD': '🇧🇭', 'OMR': '🇴🇲', 'JOD': '🇯🇴',
      'LBP': '🇱🇧', 'THB': '🇹🇭', 'VND': '🇻🇳',
      'IDR': '🇮🇩', 'MYR': '🇲🇾', 'PHP': '🇵🇭', 'TWD': '🇹🇼',
      'HUF': '🇭🇺', 'CZK': '🇨🇿', 'RON': '🇷🇴', 'BGN': '🇧🇬',
      'HRK': '🇭🇷', 'RSD': '🇷🇸', 'UAH': '🇺🇦', 'BYN': '🇧🇾',
      'KZT': '🇰🇿', 'UZS': '🇺🇿', 'KGS': '🇰🇬', 'TJS': '🇹🇯',
      'TMT': '🇹🇲', 'AFN': '🇦🇫', 'PKR': '🇵🇰', 'LKR': '🇱🇰',
      'BDT': '🇧🇩', 'NPR': '🇳🇵', 'BTN': '🇧🇹', 'MMK': '🇲🇲',
      'LAK': '🇱🇦', 'KHR': '🇰🇭', 'MOP': '🇲🇴', 'BND': '🇧🇳',
      'FJD': '🇫🇯', 'PGK': '🇵🇬', 'SBD': '🇸🇧', 'VUV': '🇻🇺',
      'WST': '🇼🇸', 'TOP': '🇹🇴', 'XPF': '🇵🇫', 'MVR': '🇲🇻',
      'SCR': '🇸🇨', 'KMF': '🇰🇲', 'DJF': '🇩🇯', 'ETB': '🇪🇹',
      'KES': '🇰🇪', 'TZS': '🇹🇿', 'UGX': '🇺🇬', 'RWF': '🇷🇼',
      'BIF': '🇧🇮', 'MWK': '🇲🇼', 'ZMW': '🇿🇲', 'BWP': '🇧🇼',
      'SZL': '🇸🇿', 'LSL': '🇱🇸', 'NAD': '🇳🇦', 'AOA': '🇦🇴',
      'MZN': '🇲🇿', 'MGA': '🇲🇬', 'MUR': '🇲🇺', 'SLL': '🇸🇱',
      'GMD': '🇬🇲', 'GNF': '🇬🇳', 'LRD': '🇱🇷', 'CDF': '🇨🇩',
      'XAF': '🇨🇲', 'XOF': '🇸🇳', 'MAD': '🇲🇦', 'DZD': '🇩🇿',
      'TND': '🇹🇳', 'LYD': '🇱🇾', 'SDG': '🇸🇩', 'SSP': '🇸🇸',
      'ERN': '🇪🇷', 'SOS': '🇸🇴', 'ARS': '🇦🇷', 'CLP': '🇨🇱',
      'COP': '🇨🇴', 'PEN': '🇵🇪', 'UYU': '🇺🇾', 'VES': '🇻🇪',
      'GYD': '🇬🇾', 'SRD': '🇸🇷', 'TTD': '🇹🇹', 'BBD': '🇧🇧',
      'JMD': '🇯🇲', 'BZD': '🇧🇿', 'GTQ': '🇬🇹', 'HNL': '🇭🇳',
      'NIO': '🇳🇮', 'CRC': '🇨🇷', 'PAB': '🇵🇦', 'DOP': '🇩🇴',
      'HTG': '🇭🇹', 'CUP': '🇨🇺', 'XCD': '🇦🇬', 'AWG': '🇦🇼',
      'BMD': '🇧🇲', 'KYD': '🇰🇾', 'SHP': '🇸🇭', 'FKP': '🇫🇰',
      'MDL': '🇲🇩', 'MKD': '🇲🇰', 'ALL': '🇦🇱', 'BAM': '🇧🇦',
      'SKK': '🇸🇰', 'ISK': '🇮🇸',
    };
    
    return flagMap[currencyCode] ?? '🏳️';
  }
}
