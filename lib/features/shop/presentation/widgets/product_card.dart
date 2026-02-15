import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilemoney/core/theme/app_theme.dart';
import 'package:mobilemoney/core/design_system/app_colors.dart';
import 'package:mobilemoney/core/design_system/app_text_styles.dart';
import 'package:mobilemoney/features/shop/domain/entities/product.dart';
import 'package:mobilemoney/features/shop/presentation/manager/shop_providers.dart';
import 'package:mobilemoney/features/shop/presentation/utils/icon_mapper.dart';

class ProductCard extends ConsumerStatefulWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  ConsumerState<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<ProductCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = ref.watch(wishlistProvider).contains(widget.product.id);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image / Icon Top Area
                Stack(
                  children: [
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary.withValues(alpha: 0.06),
                            AppColors.primary.withValues(alpha: 0.02),
                          ],
                        ),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      child: Center(
                        child: Hero(
                          tag: 'product_icon_${widget.product.id}',
                          child: Icon(
                            IconMapper.getIcon(widget.product.icon),
                            size: 56,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    // Wishlist Heart
                    Positioned(
                      top: 12,
                      right: 12,
                      child: GestureDetector(
                        onTap: () {
                          ref.read(wishlistProvider.notifier).toggleFavorite(widget.product.id);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            size: 18,
                            color: isFavorite ? Colors.red : AppColors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.category.toUpperCase(),
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                            color: AppColors.grey.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.product.name,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Text(
                          '${widget.product.price.toInt()} FCFA',
                          style: AppTextStyles.price.copyWith(
                            fontSize: 17,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                   ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Achat immédiat initié !'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.mtnYellow,
                                  foregroundColor: AppTheme.black,
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  minimumSize: Size.zero,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 0,
                                ).copyWith(
                                  overlayColor: WidgetStateProperty.all(Colors.black.withValues(alpha: 0.05)),
                                  textStyle: WidgetStateProperty.all(const TextStyle(
                                    fontSize: 12, 
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Outfit',
                                  )),
                                ),
                                child: const Text('Acheter'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Material(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                              child: InkWell(
                                onTap: () {
                                   ref.read(cartProvider.notifier).addToCart(widget.product);
                                   ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${widget.product.name} ajouté au panier'),
                                      duration: const Duration(seconds: 1),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(Icons.shopping_bag_outlined, size: 18, color: AppColors.primary),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
