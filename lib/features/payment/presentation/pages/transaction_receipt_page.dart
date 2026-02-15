import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants.dart';

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
    final reference = 'MTN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    final date = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

    // Show specialized toast after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSpecializedToast(context);
    });

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Reçu de transaction'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go(AppRoutes.home),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Success Icon
            const CircleAvatar(
              radius: 36,
              backgroundColor: Colors.green,
              child: Icon(Icons.check, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 16),
            const Text(
              'Transfert réussi !',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 32),

            // Receipt Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildReceiptRow('Référence', reference, isBold: true),
                  _buildReceiptRow('Date', date),
                  const Divider(height: 32),
                  _buildReceiptRow('Destinataire', name, isBold: true),
                  _buildReceiptRow('Numéro', number),
                  const Divider(height: 32),
                  _buildReceiptRow('Montant envoyé', '${NumberFormat('#,##0').format(amount)} FCFA'),
                  _buildReceiptRow('Frais de service', '${NumberFormat('#,##0').format(fees)} FCFA'),
                  const Divider(height: 32),
                  _buildReceiptRow(
                    'Total prélevé',
                    '${NumberFormat('#,##0').format(total)} FCFA',
                    isBold: true,
                    valueColor: AppTheme.black,
                    fontSize: 18,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Actions
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.share_outlined),
                label: const Text('Partager le reçu'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.mtnYellow,
                  foregroundColor: AppTheme.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Retour à l\'accueil', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isBold = false, Color? valueColor, double fontSize = 14}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: valueColor ?? AppTheme.black,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }

  void _showSpecializedToast(BuildContext context) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    
    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF323232),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppTheme.mtnYellow, size: 28),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Vérifiez votre reçu',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'En cas d\'erreur, intervenez vite. Délai d\'annulation limité.',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => entry.remove(),
                  child: const Text('OK', style: TextStyle(color: AppTheme.mtnYellow, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    
    // Auto remove after 8 seconds
    Future.delayed(const Duration(seconds: 8), () {
      if (entry.mounted) entry.remove();
    });
  }
}
