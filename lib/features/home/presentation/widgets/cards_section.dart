import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../cards/domain/entities/card_model.dart';
import '../../../cards/presentation/widgets/payment_card_widget.dart';

class CardsSection extends StatelessWidget {
  const CardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data using the new model
    final cards = [
      PaymentCard(
        id: '1',
        cardNumber: '•••• •••• •••• 4582',
        holderName: 'Yello User',
        expiryDate: '12/26',
        type: PaymentCardType.visa,
        balance: 150000,
        gradientColors: [Colors.black, Colors.grey.shade800],
      ),
      PaymentCard(
        id: '2',
        cardNumber: '677 00 00 00',
        holderName: 'Yello User',
        expiryDate: 'No Expiry',
        type: PaymentCardType.momo,
        balance: 45000,
        gradientColors: [AppTheme.mtnYellow, Colors.orange.shade700],
      ),
       PaymentCard(
        id: '3',
        cardNumber: '•••• •••• •••• 1234',
        holderName: 'Yello User',
        expiryDate: '08/28',
        type: PaymentCardType.mastercard,
        balance: 85000,
        gradientColors: [Colors.blue.shade900, Colors.blue.shade700],
      ),
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'My Cards',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.black,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Add New'),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 200, // Increased height for better shadow visibility
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            itemCount: cards.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.md, bottom: 10),
                child: PaymentCardWidget(
                  card: cards[index],
                  isCompact: true,
                  onTap: () {},
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
