import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants.dart';
import '../../../../core/design_system/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_transitions.dart';
import '../../domain/entities/transaction.dart';
import '../widgets/transaction_detail_sheet.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  String _selectedFilter = 'Tous';
  final TextEditingController _searchController = TextEditingController();

  final List<Transaction> _allTransactions = [
    Transaction(
      id: 'TXN-98432',
      title: 'Achat Boutique Walliss',
      subtitle: 'Aujourd\'hui, 15:42',
      amount: 45000,
      date: DateTime.now(),
      type: TransactionType.bill,
      status: TransactionStatus.completed,
      recipient: 'Boutique Walliss - POS Terminal',
      reference: 'WAL-POS-98432',
      fee: 0,
    ),
    Transaction(
      id: 'TXN-87421',
      title: 'Envoi à Marie Claire',
      subtitle: 'Aujourd\'hui, 11:20',
      amount: 25000,
      date: DateTime.now(),
      type: TransactionType.send,
      status: TransactionStatus.completed,
      recipient: '+237 677 88 99 00',
      reference: 'WAL-TX-87421',
      fee: 250,
    ),
    Transaction(
      id: 'TXN-76319',
      title: 'Reçu de Paul Kamga',
      subtitle: 'Hier, 18:05',
      amount: 120000,
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: TransactionType.receive,
      status: TransactionStatus.completed,
      sender: '+237 699 12 34 56',
      reference: 'WAL-IN-76319',
      fee: 0,
    ),
    Transaction(
      id: 'TXN-65208',
      title: 'Rechargement Solde (Dépôt)',
      subtitle: 'Hier, 09:12',
      amount: 50000,
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: TransactionType.bank,
      status: TransactionStatus.completed,
      sender: 'Point Marchand Walliss',
      reference: 'WAL-DEP-65208',
      fee: 0,
    ),
    Transaction(
      id: 'TXN-54197',
      title: 'Envoi à Samuel Eto\'o',
      subtitle: 'Il y a 3 jours',
      amount: 15000,
      date: DateTime.now().subtract(const Duration(days: 3)),
      type: TransactionType.send,
      status: TransactionStatus.completed,
      recipient: '+237 671 22 33 44',
      reference: 'WAL-TX-54197',
      fee: 150,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Transaction> get _filteredTransactions {
    return _allTransactions.where((t) {
      final query = _searchController.text.toLowerCase();
      final matchesQuery = t.title.toLowerCase().contains(query) ||
          (t.recipient?.toLowerCase().contains(query) ?? false) ||
          (t.sender?.toLowerCase().contains(query) ?? false);

      if (!matchesQuery) return false;

      switch (_selectedFilter) {
        case 'Envois':
          return t.type == TransactionType.send;
        case 'Réceptions':
          return t.type == TransactionType.receive;
        case 'Boutique':
          return t.type == TransactionType.bill;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.spotifyBlack,
      appBar: AppBar(
        backgroundColor: AppColors.spotifyBlack,
        elevation: 0,
        title: const Text(
          'Transactions & Échanges',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.send_rounded, color: AppColors.monarchPurpleNeon),
            tooltip: 'Nouvel Envoi',
            onPressed: () => context.push(AppRoutes.recipientSelection),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.spotifyCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF282828), width: 0.8),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Rechercher une transaction...',
                  hintStyle: const TextStyle(color: AppColors.spotifyGrey, fontSize: 14),
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.spotifyGrey, size: 20),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppColors.spotifyGrey, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          // Filters Pills
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 8),
            child: Row(
              children: ['Tous', 'Envois', 'Réceptions', 'Boutique'].map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedFilter = filter);
                    },
                    backgroundColor: AppColors.spotifyCard,
                    selectedColor: AppColors.monarchPurpleNeon.withValues(alpha: 0.25),
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.monarchPurpleNeon : AppColors.spotifyGrey,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? AppColors.monarchPurpleNeon : const Color(0xFF282828),
                        width: 0.8,
                      ),
                    ),
                    showCheckmark: false,
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 8),

          // Transactions List
          Expanded(
            child: _filteredTransactions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.spotifyGrey.withValues(alpha: 0.5)),
                        const SizedBox(height: 12),
                        const Text(
                          'Aucune transaction trouvée',
                          style: TextStyle(color: AppColors.spotifyGrey, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 8, AppSpacing.lg, 80),
                    itemCount: _filteredTransactions.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = _filteredTransactions[index];
                      return Material(
                        color: AppColors.spotifyCard,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: Color(0xFF242424), width: 0.8),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          onTap: () {
                            AppTransitions.showAppBottomSheet(
                              context: context,
                              child: TransactionDetailSheet(transaction: item),
                            );
                          },
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: _getColor(item.type).withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(_getIcon(item.type), color: _getColor(item.type), size: 20),
                          ),
                          title: Text(
                            item.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            item.subtitle,
                            style: const TextStyle(color: AppColors.spotifyGrey, fontSize: 12),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${item.type == TransactionType.receive ? '+' : '-'} ${item.amount.toInt()} F',
                                style: TextStyle(
                                  color: item.type == TransactionType.receive
                                      ? const Color(0xFF1DB954) // Green Spotify
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Succès',
                                style: TextStyle(
                                  color: Color(0xFF1DB954),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
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

  IconData _getIcon(TransactionType type) {
    switch (type) {
      case TransactionType.send:
        return Icons.arrow_upward_rounded;
      case TransactionType.receive:
        return Icons.arrow_downward_rounded;
      case TransactionType.bill:
        return Icons.shopping_bag_outlined;
      case TransactionType.bank:
        return Icons.account_balance_wallet_rounded;
      default:
        return Icons.swap_horiz_rounded;
    }
  }

  Color _getColor(TransactionType type) {
    switch (type) {
      case TransactionType.send:
        return AppColors.monarchPurpleNeon;
      case TransactionType.receive:
        return const Color(0xFF1DB954); // Spotify green
      case TransactionType.bill:
        return Colors.orangeAccent;
      case TransactionType.bank:
        return Colors.blueAccent;
      default:
        return AppColors.spotifyGrey;
    }
  }
}
