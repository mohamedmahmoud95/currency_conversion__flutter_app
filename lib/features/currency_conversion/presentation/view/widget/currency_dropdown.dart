import 'package:flutter/material.dart';
import 'package:lab_test_1/features/currency_conversion/domain/entities/currency.dart';
import 'package:lab_test_1/features/currency_conversion/domain/services/currency_service.dart';
import 'currency_search_dialog.dart';

class CurrencyDropdown extends StatefulWidget {
  final String label;
  final Currency selectedCurrency;
  final Function(Currency) onCurrencyChanged;
  final CurrencyService currencyService;

  const CurrencyDropdown({
    super.key,
    required this.label,
    required this.selectedCurrency,
    required this.onCurrencyChanged,
    required this.currencyService,
  });

  @override
  State<CurrencyDropdown> createState() => _CurrencyDropdownState();
}

class _CurrencyDropdownState extends State<CurrencyDropdown> {
  List<Currency> _currencies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrencies();
  }

  Future<void> _loadCurrencies() async {
    try {
      final currencies = await widget.currencyService.getSupportedCurrencies();
      if (mounted) {
        setState(() {
          _currencies = currencies;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _currencies = DefaultCurrencies.fallbackCurrencies;
          _isLoading = false;
        });
      }
    }
  }

  void _showCurrencySearchDialog() {
        showDialog(
          context: context,
          builder: (context) => CurrencySearchDialog(
        currencies: _currencies,
        selectedCurrency: widget.selectedCurrency,
        onCurrencySelected: (currency) {
          widget.onCurrencyChanged(currency);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _isLoading ? null : _showCurrencySearchDialog,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey[50]
                  : Colors.grey[800],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: _isLoading
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 12),
                        Text('Loading currencies...'),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Row(
                      children: [
                        Text(
                          widget.selectedCurrency.flag,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.selectedCurrency.code,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                widget.selectedCurrency.name,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.search,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}