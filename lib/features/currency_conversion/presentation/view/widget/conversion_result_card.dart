import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab_test_1/features/currency_conversion/domain/entities/currency.dart';
import 'package:lab_test_1/features/currency_conversion/domain/entities/exchange_rate.dart';

class ConversionResultCard extends StatelessWidget {
  final Currency fromCurrency;
  final Currency toCurrency;
  final double amount;
  final double convertedAmount;
  final ExchangeRate? exchangeRate;
  final bool isLoading;
  final String? errorMessage;
  final DateTime? lastUpdated;

  const ConversionResultCard({
    super.key,
    required this.fromCurrency,
    required this.toCurrency,
    required this.amount,
    required this.convertedAmount,
    this.exchangeRate,
    this.isLoading = false,
    this.errorMessage,
    this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            else if (errorMessage != null)
              _buildErrorState(context)
            else
              _buildConversionResult(context),
            
            const SizedBox(height: 24),
            
            if (exchangeRate != null && !isLoading && errorMessage == null)
              _buildExchangeRates(context),
            
            const SizedBox(height: 16),
            
            if (lastUpdated != null && !isLoading && errorMessage == null)
              _buildLastUpdated(context),
          ],
        ),
      ),
    );
  }

  Widget _buildConversionResult(BuildContext context) {
    final formatter = NumberFormat.currency(
      symbol: '',
      decimalDigits: 2,
    );
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${formatter.format(amount)} ${fromCurrency.code} =',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white.withAlpha(225),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${toCurrency.symbol}${formatter.format(convertedAmount)}',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.error_outline,
          color: Colors.white,
          size: 48,
        ),
        const SizedBox(height: 16),
        Text(
          'Error',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          errorMessage ?? 'Something went wrong',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white.withAlpha(225),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildExchangeRates(BuildContext context) {
    final formatter = NumberFormat.currency(
      symbol: '',
      decimalDigits: 6,
    );
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1 ${fromCurrency.code} = ${formatter.format(exchangeRate!.rate)} ${toCurrency.code}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1 ${toCurrency.code} = ${formatter.format(exchangeRate!.reverseRate)} ${fromCurrency.code}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withAlpha(200),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLastUpdated(BuildContext context) {
    final formatter = DateFormat('MMM dd, yyyy HH:mm');
    
    return Row(
      children: [
        Icon(
          Icons.update,
          color: Colors.white.withAlpha(175),
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          'Last updated: ${formatter.format(lastUpdated!)}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withAlpha(175)
          ),
        ),
      ],
    );
  }

}
