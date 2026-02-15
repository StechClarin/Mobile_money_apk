import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/design_system/app_colors.dart';
import '../../domain/entities/bundle.dart';

class BundleCard extends StatelessWidget {
  final Bundle bundle;
  final VoidCallback onBuy;

  const BundleCard({
    super.key,
    required this.bundle,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onBuy,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Icon & Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _getCategoryColor().withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(_getCategoryIcon(), color: _getCategoryColor(), size: 20),
                    ),
                    _buildBadge(),
                  ],
                ),
                const Spacer(),

                // 2. Info
                Text(
                  bundle.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppTheme.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  bundle.description,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),

                // 3. Price & Action
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${bundle.price.toInt()} FCFA',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            color: _getCategoryColor(),
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          bundle.validity,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppTheme.mtnYellow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.add, color: AppTheme.black, size: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge() {
    String? amount = bundle.dataAmount ?? bundle.minutesAmount;
    if (amount == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        amount,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  IconData _getCategoryIcon() {
    switch (bundle.type) {
      case BundleType.internet: return Icons.wifi;
      case BundleType.call: return Icons.call;
      case BundleType.sms: return Icons.sms;
      case BundleType.special: return Icons.star;
      case BundleType.mixte: return Icons.layers;
      case BundleType.oversize: return Icons.add_chart;
      case BundleType.vsd: return Icons.weekend;
    }
  }

  Color _getCategoryColor() {
    switch (bundle.type) {
      case BundleType.internet: return Colors.blue;
      case BundleType.call: return Colors.green;
      case BundleType.sms: return Colors.orange;
      case BundleType.special: return Colors.purple;
      case BundleType.mixte: return Colors.teal;
      case BundleType.oversize: return Colors.red;
      case BundleType.vsd: return Colors.indigo;
    }
  }
}
