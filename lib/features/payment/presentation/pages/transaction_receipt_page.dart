import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants.dart';
import '../../../../core/design_system/app_colors.dart';

class TransactionReceiptPage extends StatelessWidget {
  final Map<String, dynamic> transactionDetails;

  const TransactionReceiptPage({
    super.key,
    required this.transactionDetails,
  });

  @override
  Widget build(BuildContext context) {
    final name = transactionDetails['name'] ?? 'Inconnu';
    final number = transactionDetails['number'] ?? 'N/A';
    final amount = transactionDetails['amount'] ?? 0.0;
    final fees = transactionDetails['fees'] ?? 0.0;
    final total = amount + fees;
    final reference = 'WAL-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    final date = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.spotifyBlack,
      appBar: AppBar(
        title: const Text('Reçu officiel Walliss', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: AppColors.spotifyBlack,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () => context.go(AppRoutes.home),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Success Icon Spotify Green
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFF1DB954).withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF1DB954), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1DB954).withValues(alpha: 0.3),
                    blurRadius: 18,
                  ),
                ],
              ),
              child: const Icon(Icons.check_rounded, color: Color(0xFF1DB954), size: 40),
            ),
            const SizedBox(height: 16),
            const Text(
              'Transfert Réussi !',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            const Text(
              'Fonds transférés instantanément par Walliss',
              style: TextStyle(color: AppColors.spotifyGrey, fontSize: 13),
            ),
            const SizedBox(height: 32),

            // Receipt Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.spotifyCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF282828), width: 0.8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildReceiptRow('Référence', reference, isBold: true),
                  _buildReceiptRow('Date & Heure', date),
                  const Divider(height: 28, color: Color(0xFF282828)),
                  _buildReceiptRow('Bénéficiaire', name, isBold: true),
                  _buildReceiptRow('Numéro', number),
                  const Divider(height: 28, color: Color(0xFF282828)),
                  _buildReceiptRow('Montant net', '${NumberFormat('#,##0').format(amount)} FCFA'),
                  _buildReceiptRow('Frais de service (1%)', '${NumberFormat('#,##0').format(fees)} FCFA'),
                  const Divider(height: 28, color: Color(0xFF282828)),
                  _buildReceiptRow(
                    'Total débité',
                    '${NumberFormat('#,##0').format(total)} FCFA',
                    isBold: true,
                    valueColor: AppColors.monarchPurpleNeon,
                    fontSize: 18,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),

            // Actions
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.go(AppRoutes.home),
                icon: const Icon(Icons.done_all_rounded, color: Colors.white, size: 20),
                label: const Text('Terminer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.monarchPurpleNeon,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.share_outlined, color: Colors.white, size: 18),
                label: const Text('Partager le reçu officiel', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Color(0xFF382A54), width: 1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
    double fontSize = 14,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.spotifyGrey,
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.white,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
