import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum PaymentCardType { visa, mastercard, walliss, momo }

class PaymentCard extends Equatable {
  final String id;
  final String cardNumber;
  final String holderName;
  final String expiryDate;
  final PaymentCardType type;
  final double balance;
  final List<Color> gradientColors;
  final String cardName;
  final String cvv;
  final bool isVirtual;
  final bool isFrozen;

  const PaymentCard({
    required this.id,
    required this.cardNumber,
    required this.holderName,
    required this.expiryDate,
    required this.type,
    required this.balance,
    required this.gradientColors,
    this.cardName = 'Walliss Card',
    this.cvv = '389',
    this.isVirtual = true,
    this.isFrozen = false,
  });

  PaymentCard copyWith({
    String? id,
    String? cardNumber,
    String? holderName,
    String? expiryDate,
    PaymentCardType? type,
    double? balance,
    List<Color>? gradientColors,
    String? cardName,
    String? cvv,
    bool? isVirtual,
    bool? isFrozen,
  }) {
    return PaymentCard(
      id: id ?? this.id,
      cardNumber: cardNumber ?? this.cardNumber,
      holderName: holderName ?? this.holderName,
      expiryDate: expiryDate ?? this.expiryDate,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      gradientColors: gradientColors ?? this.gradientColors,
      cardName: cardName ?? this.cardName,
      cvv: cvv ?? this.cvv,
      isVirtual: isVirtual ?? this.isVirtual,
      isFrozen: isFrozen ?? this.isFrozen,
    );
  }

  @override
  List<Object?> get props => [
        id,
        cardNumber,
        holderName,
        expiryDate,
        type,
        balance,
        gradientColors,
        cardName,
        cvv,
        isVirtual,
        isFrozen,
      ];
}

