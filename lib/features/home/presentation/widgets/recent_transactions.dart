import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_transitions.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/presentation/widgets/transaction_detail_sheet.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data for Transactions
    final transactions = [
      Transaction(
        id: '1',
        title: 'Supermarché',
        subtitle: 'Today, 10:23 AM',
        amount: 25000,
        date: DateTime.now(),
        type: TransactionType.send,
        status: TransactionStatus.completed,
        recipient: 'Supermarché Casino',
        fee: 125,
      ),
      Transaction(
        id: '2',
        title: 'Reçu de John Doe',
        subtitle: 'Yesterday, 04:45 PM',
        amount: 50000,
        date: DateTime.now().subtract(const Duration(days: 1)),
        type: TransactionType.receive,
        status: TransactionStatus.completed,
        sender: '677 12 34 56',
        fee: 0,
      ),
      Transaction(
        id: '3',
        title: 'Crédit MTN',
        subtitle: '12 Feb, 09:15 AM',
        amount: 5000,
        date: DateTime.now().subtract(const Duration(days: 2)),
        type: TransactionType.airtime,
        status: TransactionStatus.completed,
        recipient: 'My Number',
        fee: 0,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.black,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Divider(height: 1, color: Colors.grey.shade100),
              ),
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showTransactionDetails(context, transaction),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _getIconColor(transaction.type).withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getIcon(transaction.type),
                              color: _getIconColor(transaction.type),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  transaction.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: AppTheme.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  transaction.subtitle,
                                  style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${_getPrefix(transaction.type)} ${transaction.amount.toInt()}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: _getIconColor(transaction.type),
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'FCFA',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showTransactionDetails(BuildContext context, Transaction transaction) {
    AppTransitions.showAppBottomSheet(
      context: context,
      child: TransactionDetailSheet(transaction: transaction),
    );
  }

  IconData _getIcon(TransactionType type) {
    switch (type) {
      case TransactionType.send: return Icons.shopping_cart_outlined;
      case TransactionType.receive: return Icons.arrow_downward;
      case TransactionType.airtime: return Icons.phone_android;
      default: return Icons.payment;
    }
  }

  Color _getIconColor(TransactionType type) {
    switch (type) {
      case TransactionType.send:
      case TransactionType.airtime:
        return Colors.red;
      case TransactionType.receive:
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  String _getPrefix(TransactionType type) {
    switch (type) {
      case TransactionType.send:
      case TransactionType.airtime:
        return '-';
      case TransactionType.receive:
        return '+';
      default:
        return '';
    }
  }
}
