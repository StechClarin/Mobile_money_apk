import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/services/fee_service.dart';
import 'payment_state.dart';

class PaymentController extends AutoDisposeNotifier<PaymentState> {
  late final FeeService _feeService;
  final double userBalance = 2500000; // Mock balance

  @override
  PaymentState build() {
    _feeService = FeeService();
    return const PaymentState();
  }

  void updateFromSent(double sentAmount) {
    // If input is 0 or negative
    if (sentAmount <= 0) {
      state = state.copyWith(
        amountSent: 0,
        amountReceived: 0,
        fees: 0,
        isAmountValid: true,
        errorMessage: null,
      );
      return;
    }

    // Calculate Net (Received) from Total (Sent)
    final netAmount = _feeService.calculateNetFromTotal(sentAmount);
    final fees = _feeService.calculateFeeFromTotal(sentAmount);

    _validateAndEmit(
      sent: sentAmount,
      received: netAmount,
      fees: fees,
    );
  }

  void updateFromReceived(double receivedAmount) {
    if (receivedAmount <= 0) {
      state = state.copyWith(
        amountSent: 0,
        amountReceived: 0,
        fees: 0,
        isAmountValid: true,
        errorMessage: null,
      );
      return;
    }

    // Calculate Total (Sent) from Net (Received)
    final totalAmount = _feeService.calculateTotalFromNet(receivedAmount);
    final fees = totalAmount - receivedAmount;

    _validateAndEmit(
      sent: totalAmount,
      received: receivedAmount,
      fees: fees,
    );
  }

  void _validateAndEmit({
    required double sent,
    required double received,
    required double fees,
  }) {
    if (sent > userBalance) {
      state = state.copyWith(
        amountSent: sent,
        amountReceived: received,
        fees: fees,
        isAmountValid: false,
        errorMessage: 'Solde MoMo insuffisant',
      );
    } else {
      state = state.copyWith(
        amountSent: sent,
        amountReceived: received,
        fees: fees,
        isAmountValid: true,
        errorMessage: null, // Clear error
      );
    }
  }
}

final paymentControllerProvider =
    NotifierProvider.autoDispose<PaymentController, PaymentState>(() {
  return PaymentController();
});
