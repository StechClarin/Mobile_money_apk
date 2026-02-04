import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/payment_controller.dart';
import '../providers/payment_state.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  late final TextEditingController _sentController;
  late final TextEditingController _receivedController;
  final NumberFormat _currencyFormat = NumberFormat('#,##0', 'fr_FR');

  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _sentController = TextEditingController();
    _receivedController = TextEditingController();
  }

  @override
  void dispose() {
    _sentController.dispose();
    _receivedController.dispose();
    super.dispose();
  }

  void _onSentChanged(String value) {
    if (_isUpdating) return;

    final cleanValue = value.replaceAll(RegExp(r'\D'), ''); // Strip non-digits
    final amount = double.tryParse(cleanValue) ?? 0.0;

    ref.read(paymentControllerProvider.notifier).updateFromSent(amount);
  }

  void _onReceivedChanged(String value) {
    if (_isUpdating) return;

    final cleanValue = value.replaceAll(RegExp(r'\D'), '');
    final amount = double.tryParse(cleanValue) ?? 0.0;

    ref.read(paymentControllerProvider.notifier).updateFromReceived(amount);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(paymentControllerProvider);
    
    _updateControllersIfNecessary(state);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Money'),
        backgroundColor: AppTheme.mtnYellow,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sender Input (Total)
            _buildAmountInput(
              controller: _sentController,
              label: 'Montant débité (frais inclus)',
              onChanged: _onSentChanged,
              isError: !state.isAmountValid,
            ),
            
            const SizedBox(height: AppSpacing.lg),
            
            // Receiver Input (Net)
            _buildAmountInput(
              controller: _receivedController,
              label: 'Le destinataire reçoit',
              onChanged: _onReceivedChanged,
              isError: false, 
            ),

            const SizedBox(height: AppSpacing.md),

            // Fee Info
            if (state.fees > 0)
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 16, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      'Frais appliqués : ${_formatCurrency(state.fees)} FCFA',
                      style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            
            // Error Message
            if (state.errorMessage != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                state.errorMessage!,
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ],

            const SizedBox(height: AppSpacing.xl),

            // Action Button
            ElevatedButton(
              onPressed: (state.amountSent > 0 && state.isAmountValid)
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Transfert initié !')),
                      );
                    }
                  : null, 
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.mtnYellow,
                foregroundColor: AppTheme.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: (state.amountSent > 0 && state.isAmountValid) ? 4 : 0,
              ),
              child: const Text('Envoyer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountInput({
    required TextEditingController controller,
    required String label,
    required ValueChanged<String> onChanged,
    required bool isError,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isError ? Colors.red : Colors.grey.shade300,
              width: isError ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            onChanged: onChanged,
            inputFormatters: [
               FilteringTextInputFormatter.digitsOnly,
               _CurrencyInputFormatter(),
            ],
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              suffixText: 'FCFA',
              suffixStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
  
  void _updateControllersIfNecessary(PaymentState state) {
    String format(double val) {
       if (val == 0) return '';
       return _currencyFormat.format(val).trim(); 
    }

    final sentText = format(state.amountSent);
    final receivedText = format(state.amountReceived);

    _isUpdating = true;
    
    // Check if we need to update to avoid cursor jumps / loops
    // Ideally we check if text matches value.
    if (_shouldUpdate(_sentController, state.amountSent)) {
        _sentController.value = TextEditingValue(
          text: sentText,
          selection: TextSelection.collapsed(offset: sentText.length),
        );
    }

    if (_shouldUpdate(_receivedController, state.amountReceived)) {
        _receivedController.value = TextEditingValue(
          text: receivedText,
          selection: TextSelection.collapsed(offset: receivedText.length),
        );
    }

    _isUpdating = false;
  }
  
  bool _shouldUpdate(TextEditingController controller, double stateValue) {
      final clean = controller.text.replaceAll(RegExp(r'\D'), '');
      final currentVal = double.tryParse(clean) ?? 0.0;
      // Update if current text value differs from state value by > 1 unit (due to rounding) or logic
      return (currentVal - stateValue).abs() > 0.5; 
  }

  String _formatCurrency(double value) {
    return _currencyFormat.format(value);
  }
}

class _CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,##0', 'fr_FR');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    
    final String cleanText = newValue.text.replaceAll(RegExp(r'\D'), '');
    final double value = double.tryParse(cleanText) ?? 0.0;
    
    final String newText = _formatter.format(value).trim();

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
