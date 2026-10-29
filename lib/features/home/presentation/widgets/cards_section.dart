import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/design_system/app_colors.dart';
import '../../../cards/domain/entities/card_model.dart';
import '../../../cards/presentation/widgets/payment_card_widget.dart';

class CardsSection extends StatelessWidget {
  const CardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    const cards = [
      PaymentCard(
        id: '1',
        cardName: 'Walliss Shadow Monarch',
        cardNumber: '•••• •••• •••• 9412',
        holderName: 'Clarin S.',
        expiryDate: '09/29',
        type: PaymentCardType.walliss,
        balance: 450000,
        gradientColors: [
          Color(0xFF0F0B1E),
          Color(0xFF2A085C),
          Color(0xFF6B21A8),
        ],
        isVirtual: true,
      ),
      PaymentCard(
        id: '2',
        cardName: 'Walliss Obsidian Black',
        cardNumber: '•••• •••• •••• 3180',
        holderName: 'Clarin S.',
        expiryDate: '12/28',
        type: PaymentCardType.visa,
        balance: 1850000,
        gradientColors: [
          Color(0xFF141414),
          Color(0xFF242424),
          Color(0xFF0A0A0A),
        ],
        isVirtual: false,
      ),
      PaymentCard(
        id: '3',
        cardName: 'Walliss Cyber Edition',
        cardNumber: '•••• •••• •••• 6204',
        holderName: 'Clarin S.',
        expiryDate: '04/30',
        type: PaymentCardType.mastercard,
        balance: 125000,
        gradientColors: [
          Color(0xFF0D1B2A),
          Color(0xFF1B263B),
          Color(0xFF415A77),
        ],
        isVirtual: true,
      ),
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mes Cartes',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  '+ Nouvelle',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.monarchPurpleNeon,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 200,
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

