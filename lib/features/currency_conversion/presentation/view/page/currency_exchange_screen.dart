import 'package:flutter/material.dart';
import 'package:lab_test_1/core/app_theme/theme_provider.dart';
import 'package:lab_test_1/features/currency_conversion/domain/entities/currency.dart';
import 'package:lab_test_1/features/currency_conversion/domain/entities/exchange_rate.dart';
import 'package:lab_test_1/features/currency_conversion/domain/repositories/currency_repository.dart';
import 'package:lab_test_1/features/currency_conversion/domain/services/currency_service.dart';
import 'package:lab_test_1/features/currency_conversion/data/repositories/currency_repository_impl.dart';
import 'package:lab_test_1/features/currency_conversion/data/datasources/currency_api_service.dart';
import '../widget/conversion_input_card.dart';
import '../widget/conversion_display_card.dart';

class CurrencyExchangeScreen extends StatefulWidget {
  const CurrencyExchangeScreen({super.key});

  @override
  State<CurrencyExchangeScreen> createState() => _CurrencyExchangeScreenState();
}

class _CurrencyExchangeScreenState extends State<CurrencyExchangeScreen> {
  final TextEditingController _amountController = TextEditingController();
  final CurrencyRepository _currencyRepository = CurrencyRepositoryImpl(
    apiService: CurrencyApiService(),
  );
  final CurrencyService _currencyService = CurrencyService(
    repository: CurrencyRepositoryImpl(apiService: CurrencyApiService()),
  );

  Currency? _fromCurrency;
  Currency? _toCurrency;
  ExchangeRate? _currentExchangeRate;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeCurrencies();
    _amountController.addListener(_onAmountChanged);
  }

  void _onAmountChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _initializeCurrencies() async {
    try {
      final currencies = await _currencyService.getSupportedCurrencies();
      if (mounted && currencies.isNotEmpty) {
        setState(() {
          _fromCurrency = currencies.first;
          _toCurrency = currencies.length > 1 ? currencies[1] : currencies.first;
        });
      }
    } catch (e) {
      setState(() {
        _fromCurrency = DefaultCurrencies.fallbackCurrencies.first;
        _toCurrency = DefaultCurrencies.fallbackCurrencies[1];
      });
    }
  }

  @override
  void dispose() {
    _amountController.removeListener(_onAmountChanged);
    _amountController.dispose();
    super.dispose();
  }


  Future<void> _fetchExchangeRate() async {
    if (_fromCurrency == null || _toCurrency == null) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _currencyRepository.getExchangeRate(
        fromCurrency: _fromCurrency!.code,
        toCurrency: _toCurrency!.code,
      );

      if (response.success && response.data != null) {
        setState(() {
          _currentExchangeRate = response.data;
        });
      } else {
        setState(() {
          _errorMessage = response.error ?? 'Failed to fetch exchange rate';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Network error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _swapCurrencies() {
    if (_fromCurrency == null || _toCurrency == null) return;
    
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
      _currentExchangeRate = null;
    });
    _fetchExchangeRate();
  }

  void _resetFields() {
    setState(() {
      _amountController.clear();
      _fromCurrency = DefaultCurrencies.fallbackCurrencies.first;
      _toCurrency = DefaultCurrencies.fallbackCurrencies[1];
      _currentExchangeRate = null;
      _errorMessage = null;
    });
  }

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an amount';
    }
    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Please enter a valid number';
    }
    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }
    if (amount > 999999999) {
      return 'Amount is too large';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('بكام النهاردة؟'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              final themeProvider = ThemeProvider.of(context);
              themeProvider?.toggleTheme();
            },
            tooltip: Theme.of(context).brightness == Brightness.light
                ? 'Switch to Dark Mode'
                : 'Switch to Light Mode',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

              ConversionInputCard(
              amountController: _amountController,
              fromCurrency: _fromCurrency,
              toCurrency: _toCurrency,
              currencyService: _currencyService,
              isLoading: _isLoading,
              validateAmount: _validateAmount,
              onFromCurrencyChanged: (currency) {
                setState(() {
                  _fromCurrency = currency;
                  _currentExchangeRate = null;
                });
                _fetchExchangeRate();
              },
              onToCurrencyChanged: (currency) {
                setState(() {
                  _toCurrency = currency;
                  _currentExchangeRate = null;
                });
                _fetchExchangeRate();
              },
              onSwapCurrencies: _swapCurrencies,
              onConvert: _fetchExchangeRate,
            ),
            
            const SizedBox(height: 24),
            
            if (_fromCurrency != null && _toCurrency != null && 
                (_amountController.text.isNotEmpty || _currentExchangeRate != null || _isLoading || _errorMessage != null))
              _buildConversionDisplayCard(),
            
            const SizedBox(height: 24),
            
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildConversionDisplayCard() {
    return ConversionDisplayCard(
      fromCurrency: _fromCurrency!,
      toCurrency: _toCurrency!,
      amount: _amountController.text.isNotEmpty 
          ? double.tryParse(_amountController.text) ?? 0.0 
          : 0.0,
      exchangeRate: _currentExchangeRate,
      isLoading: _isLoading,
      errorMessage: _errorMessage,
    );
  }

  Widget _buildResetFieldsButton() {
    return OutlinedButton(
      onPressed: _resetFields,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text('Reset'),
    );
  }

  Widget _buildBackButton() {
    return ElevatedButton(
      onPressed: () => Navigator.pop(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[600],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text('Back'),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(child: _buildResetFieldsButton()),
        const SizedBox(width: 16),
        Expanded(child: _buildBackButton()),
      ],
    );
  }
}
