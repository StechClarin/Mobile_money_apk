import 'package:equatable/equatable.dart';

class PaymentEntity extends Equatable {
  final String id;
  final double amount;
  final String recipient;
  final DateTime date;

  const PaymentEntity({
    required this.id,
    required this.amount,
    required this.recipient,
    required this.date,
  });

  @override
  List<Object?> get props => [id, amount, recipient, date];
}
