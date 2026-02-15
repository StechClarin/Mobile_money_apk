import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/transaction.dart';

class TransactionDetailSheet extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailSheet({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');
    final amountColor = _getAmountColor(transaction.type);
    final amountPrefix = _getAmountPrefix(transaction.type);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Drag Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // 2. Header (Status Icon & Title)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: amountColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(_getTransactionIcon(transaction.type), color: amountColor, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            transaction.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.black),
          ),
          const SizedBox(height: 8),
          Text(
            _getStatusText(transaction.status),
            style: TextStyle(
              color: _getStatusColor(transaction.status),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),

          // 3. Amount Section
          Text(
            '$amountPrefix ${NumberFormat('#,###').format(transaction.amount)} FCFA',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: amountColor,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 32),

          // 4. Details List
          _buildDetailRow('Date & Heure', dateFormat.format(transaction.date)),
          _buildDetailRow('Référence', transaction.reference ?? 'REF-${transaction.id.toUpperCase()}'),
          if (transaction.recipient != null) _buildDetailRow('Destinataire', transaction.recipient!),
          if (transaction.sender != null) _buildDetailRow('Expéditeur', transaction.sender!),
          _buildDetailRow('Frais', '${NumberFormat('#,###').format(transaction.fee ?? 0)} FCFA'),
          _buildDetailRow('Statut', _getStatusText(transaction.status)),

          const SizedBox(height: 32),

          // 5. Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.share_outlined),
                  label: const Text('Partager'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.download_outlined),
                  label: const Text('Reçu'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.mtnYellow,
                    foregroundColor: AppTheme.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.black)),
        ],
      ),
    );
  }

  Color _getAmountColor(TransactionType type) {
    switch (type) {
      case TransactionType.send:
      case TransactionType.bill:
      case TransactionType.airtime:
        return Colors.red;
      case TransactionType.receive:
      case TransactionType.bank:
        return Colors.green;
    }
  }

  String _getAmountPrefix(TransactionType type) {
    switch (type) {
      case TransactionType.send:
      case TransactionType.bill:
      case TransactionType.airtime:
        return '-';
      case TransactionType.receive:
      case TransactionType.bank:
        return '+';
    }
  }

  IconData _getTransactionIcon(TransactionType type) {
    switch (type) {
      case TransactionType.send: return Icons.send;
      case TransactionType.receive: return Icons.arrow_downward;
      case TransactionType.bill: return Icons.receipt_long;
      case TransactionType.airtime: return Icons.phone_android;
      case TransactionType.bank: return Icons.account_balance;
    }
  }

  String _getStatusText(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed: return 'Terminé';
      case TransactionStatus.pending: return 'En attente';
      case TransactionStatus.failed: return 'Échoué';
    }
  }

  Color _getStatusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed: return Colors.green;
      case TransactionStatus.pending: return Colors.orange;
      case TransactionStatus.failed: return Colors.red;
    }
  }
}
