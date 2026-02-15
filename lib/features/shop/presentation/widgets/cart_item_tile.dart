import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilemoney/features/shop/domain/entities/cart_item.dart';
import 'package:mobilemoney/features/shop/presentation/manager/shop_providers.dart';
import 'package:mobilemoney/features/shop/presentation/utils/icon_mapper.dart';
import 'package:mobilemoney/core/design_system/app_text_styles.dart';
import 'package:mobilemoney/core/design_system/app_colors.dart';

class CartItemTile extends ConsumerWidget {
  final CartItem item;

  const CartItemTile({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              IconMapper.getIcon(item.product.icon),
              color: AppColors.primary,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.product.price.toStringAsFixed(0)} FCFA',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _buildActionButton(
                icon: Icons.remove,
                onTap: () {
                  ref.read(cartProvider.notifier).updateQuantity(item.product.id, item.quantity - 1);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  '${item.quantity}',
                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              _buildActionButton(
                icon: Icons.add,
                onTap: () {
                  ref.read(cartProvider.notifier).updateQuantity(item.product.id, item.quantity + 1);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: Colors.grey.shade600),
      ),
    );
  }
}
