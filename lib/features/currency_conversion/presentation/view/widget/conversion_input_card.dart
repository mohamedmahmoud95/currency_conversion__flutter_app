import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lab_test_1/core/app_theme/app_colors.dart';
import 'package:lab_test_1/features/currency_conversion/domain/entities/currency.dart';
import 'package:lab_test_1/features/currency_conversion/domain/services/currency_service.dart';
import 'input_field.dart';
import 'currency_dropdown.dart';

class ConversionInputCard extends StatelessWidget {
  final TextEditingController amountController;
  final Currency? fromCurrency;
  final Currency? toCurrency;
  final CurrencyService currencyService;
  final bool isLoading;
  final String? Function(String?) validateAmount;
  final Function(Currency) onFromCurrencyChanged;
  final Function(Currency) onToCurrencyChanged;
  final VoidCallback onSwapCurrencies;
  final VoidCallback onConvert;

  const ConversionInputCard({
    super.key,
    required this.amountController,
    required this.fromCurrency,
    required this.toCurrency,
    required this.currencyService,
    required this.isLoading,
    required this.validateAmount,
    required this.onFromCurrencyChanged,
    required this.onToCurrencyChanged,
    required this.onSwapCurrencies,
    required this.onConvert,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Amount input
            InputField(
              label: 'Amount',
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              hintText: '0.00',
              errorText: validateAmount(amountController.text),
            ),
            
            const SizedBox(height: 24),
            
            Row(
              children: [
                // From currency
                Expanded(
                  child: fromCurrency != null
                      ? CurrencyDropdown(
                          label: 'Base Currency',
                          selectedCurrency: fromCurrency!,
                          currencyService: currencyService,
                          onCurrencyChanged: onFromCurrencyChanged,
                        )
                      : const SizedBox(
                          height: 56,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                ),
                
                const SizedBox(width: 16),
                
                // Swap button
                SizedBox(
                  height: 48,
                  child: IconButton(
                    onPressed: onSwapCurrencies,
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.swap_vert,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // To currency
                Expanded(
                  child: toCurrency != null
                      ? CurrencyDropdown(
                          label: 'Foreign Currency',
                          selectedCurrency: toCurrency!,
                          currencyService: currencyService,
                          onCurrencyChanged: onToCurrencyChanged,
                        )
                      : const SizedBox(
                          height: 56,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Convert button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isLoading ? null : onConvert,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Convert',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}
