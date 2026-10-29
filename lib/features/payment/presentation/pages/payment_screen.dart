import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/design_system/app_colors.dart';
import '../providers/payment_controller.dart';
import '../providers/payment_state.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final String? recipientName;
  final String? recipientNumber;

  const PaymentScreen({
    super.key,
    this.recipientName,
    this.recipientNumber,
  });

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
      backgroundColor: AppColors.spotifyBlack,
      appBar: AppBar(
        title: const Text('Transférer de l\'argent', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: AppColors.spotifyBlack,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Recipient Info Card (Spotify Dark)
            if (widget.recipientName != null || widget.recipientNumber != null)
              Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.spotifyCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF282828), width: 0.8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF26193E),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF382A54)),
                      ),
                      child: const Icon(Icons.person_rounded, color: AppColors.monarchPurpleNeon, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.recipientName ?? 'Destinataire inconnu',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.recipientNumber ?? '',
                            style: const TextStyle(color: AppColors.spotifyGrey, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.spotifyGrey),
                      onPressed: () => context.pop(),
                    ),
                  ],
                ),
              ),

            // Sender Input (Total)
            _buildAmountInput(
              controller: _sentController,
              label: 'Montant à débiter (frais inclus)',
              onChanged: _onSentChanged,
              isError: !state.isAmountValid,
            ),
            
            const SizedBox(height: AppSpacing.lg),
            
            // Receiver Input (Net)
            _buildAmountInput(
              controller: _receivedController,
              label: 'Le destinataire recevra net',
              onChanged: _onReceivedChanged,
              isError: false, 
            ),

            const SizedBox(height: AppSpacing.md),

            // Fee Info
            if (state.fees > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF26193E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF382A54)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.monarchPurpleNeon),
                    const SizedBox(width: 8),
                    Text(
                      'Frais de transfert : ${_formatCurrency(state.fees)} FCFA (1%)',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                  ],
                ),
              ),
            
            // Error Message
            if (state.errorMessage != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                state.errorMessage!,
                style: const TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],

            const SizedBox(height: AppSpacing.xl),

            // Action Button
            ElevatedButton(
              onPressed: (state.amountSent > 0 && state.isAmountValid)
                  ? () {
                      context.push(
                        AppRoutes.transactionReceipt,
                        extra: {
                          'name': widget.recipientName ?? 'Destinataire inconnu',
                          'number': widget.recipientNumber ?? '',
                          'amount': state.amountReceived,
                          'fees': state.fees,
                        },
                      );
                    }
                  : null, 
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.monarchPurpleNeon,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.spotifyHover,
                disabledForegroundColor: AppColors.spotifySubtle,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: const Text('Confirmer le transfert', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.spotifyGrey)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.spotifyCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isError ? const Color(0xFFEF4444) : const Color(0xFF282828),
              width: isError ? 1.5 : 0.8,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            onChanged: onChanged,
            inputFormatters: [
               FilteringTextInputFormatter.digitsOnly,
               _CurrencyInputFormatter(),
            ],
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            decoration: const InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              suffixText: 'FCFA',
              suffixStyle: TextStyle(fontWeight: FontWeight.bold, color: AppColors.spotifyGrey, fontSize: 15),
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
