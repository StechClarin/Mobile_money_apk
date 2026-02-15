import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/design_system/app_colors.dart';
import '../../../../core/theme/app_transitions.dart';
import '../../domain/entities/card_model.dart';
import '../widgets/payment_card_widget.dart';

class CardsPage extends StatefulWidget {
  const CardsPage({super.key});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  final TextEditingController _searchController = TextEditingController();
  
  // Mock Data
  final List<PaymentCard> _allCards = [
    PaymentCard(
      id: '1',
      cardNumber: '•••• •••• •••• 4582',
      holderName: 'Yello User',
      expiryDate: '12/26',
      type: PaymentCardType.visa,
      balance: 150000,
      gradientColors: [Colors.black, Colors.grey.shade900],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Mes Cartes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Search Bar (Premium)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher une carte...',
                prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.grey),
                fillColor: AppColors.lightGrey.withValues(alpha: 0.5),
              ),
            ),
          ),

          // 2. Vertical List (Redesigned)
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
              itemCount: _allCards.length,
              separatorBuilder: (context, index) => const SizedBox(height: 24),
              itemBuilder: (context, index) {
                return PaymentCardWidget(
                  card: _allCards[index],
                  onTap: () => _showCardDetails(context, _allCards[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showCardDetails(BuildContext context, PaymentCard card) {
    AppTransitions.showAppBottomSheet(
      context: context,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  card.type.name.toUpperCase(),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.black),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.settings_outlined, color: AppColors.black),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildDetailRow(Icons.credit_card, 'Numéro', card.cardNumber),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.person_outline, 'Titulaire', card.holderName),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.calendar_today_outlined, 'Expiration', card.expiryDate),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.account_balance_wallet_outlined, 'Solde', '${card.balance.toInt()} FCFA'),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
              child: const Text('Retour'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: AppColors.grey),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.grey, fontWeight: FontWeight.w600)),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
          ],
        ),
      ],
    );
  }
}
