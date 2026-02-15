import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum PaymentCardType { visa, mastercard, momo }

class PaymentCard extends Equatable {
  final String id;
  final String cardNumber;
  final String holderName;
  final String expiryDate;
  final PaymentCardType type;
  final double balance;
  final List<Color> gradientColors;

  const PaymentCard({
    required this.id,
    required this.cardNumber,
    required this.holderName,
    required this.expiryDate,
    required this.type,
    required this.balance,
    required this.gradientColors,
  });

  @override
  List<Object?> get props => [id, cardNumber, holderName, expiryDate, type, balance, gradientColors];
}
