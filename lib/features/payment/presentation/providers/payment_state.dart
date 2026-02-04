import 'package:equatable/equatable.dart';

class PaymentState extends Equatable {
  final double amountSent;
  final double amountReceived;
  final double fees;
  final bool isAmountValid;
  final String? errorMessage;

  const PaymentState({
    this.amountSent = 0.0,
    this.amountReceived = 0.0,
    this.fees = 0.0,
    this.isAmountValid = true,
    this.errorMessage,
  });

  PaymentState copyWith({
    double? amountSent,
    double? amountReceived,
    double? fees,
    bool? isAmountValid,
    String? errorMessage,
  }) {
    return PaymentState(
      amountSent: amountSent ?? this.amountSent,
      amountReceived: amountReceived ?? this.amountReceived,
      fees: fees ?? this.fees,
      isAmountValid: isAmountValid ?? this.isAmountValid,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        amountSent,
        amountReceived,
        fees,
        isAmountValid,
        errorMessage,
      ];
}
