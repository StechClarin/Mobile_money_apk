import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum TransactionStatus { pending, completed, failed }
enum TransactionType { send, receive, bill, airtime, bank }

@immutable
class Transaction extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final TransactionStatus status;
  final String? reference;
  final String? recipient;
  final String? sender;
  final double? fee;

  const Transaction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.type,
    required this.status,
    this.reference,
    this.recipient,
    this.sender,
    this.fee,
  });

  @override
  List<Object?> get props => [id, title, subtitle, amount, date, type, status, reference, recipient, sender, fee];
}
