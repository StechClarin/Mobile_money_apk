import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobilemoney/core/constants.dart';
import 'package:mobilemoney/core/design_system/app_colors.dart';
import 'package:mobilemoney/features/shop/domain/entities/product.dart';
import 'package:mobilemoney/features/shop/presentation/manager/shop_providers.dart';
import 'package:mobilemoney/features/shop/presentation/utils/icon_mapper.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailPage({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final isFavorite = ref.watch(wishlistProvider).contains(product.id);
    final cartCount = ref.watch(cartProvider).length;
    final allProductsAsync = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: AppColors.spotifyBlack,
      body: CustomScrollView(
        slivers: [
          // 1. Sleek SliverAppBar with Hero Icon Preview
          SliverAppBar(
            expandedHeight: 330,
            pinned: true,
            backgroundColor: AppColors.spotifyBlack,
            elevation: 0,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.spotifyBlack.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.spotifyBlack.withValues(alpha: 0.7),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: isFavorite ? const Color(0xFFEF4444) : Colors.white,
                    size: 20,
                  ),
                ),
                onPressed: () {
                  ref.read(wishlistProvider.notifier).toggleFavorite(product.id);
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Badge(
                  label: Text('$cartCount'),
                  isLabelVisible: cartCount > 0,
                  backgroundColor: AppColors.monarchPurpleNeon,
                  textColor: Colors.white,
                  child: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.spotifyBlack.withValues(alpha: 0.7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 20),
                    ),
                    onPressed: () => context.push(AppRoutes.cart),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Subtle Radial Glow
                  Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(0, -0.2),
                        radius: 0.85,
                        colors: [
                          AppColors.monarchPurpleDeep.withValues(alpha: 0.35),
                          AppColors.spotifyCard,
                          AppColors.spotifyBlack,
                        ],
                      ),
                    ),
                  ),
                  // Centered Product Graphic
                  Center(
                    child: Hero(
                      tag: 'product_icon_${product.id}',
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.spotifyElevated,
                          border: Border.all(
                            color: AppColors.monarchPurpleNeon.withValues(alpha: 0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.monarchPurple.withValues(alpha: 0.3),
                              blurRadius: 30,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          IconMapper.getIcon(product.icon),
                          size: 72,
                          color: AppColors.monarchPurpleNeon,
                        ),
                      ),
                    ),
                  ),
                  // Tag Badge if present
                  if (product.tag != null)
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: AppColors.monarchGradient,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.monarchPurple.withValues(alpha: 0.4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Text(
                          product.tag!,
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // 2. Main Product Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category & Brand
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.category.toUpperCase(),
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.monarchPurpleNeon,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${product.stock} en stock',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.greenAccent,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Product Name
                  Text(
                    product.name,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Rating & Reviews Count
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded, size: 16, color: Color(0xFFF59E0B)),
                            const SizedBox(width: 4),
                            Text(
                              product.rating.toStringAsFixed(1),
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFFF59E0B),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '(${product.reviewCount} avis vérifiés)',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.spotifyGrey,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.verified_rounded, size: 16, color: AppColors.monarchCyan),
                      const SizedBox(width: 4),
                      Text(
                        'Certifié Walliss',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.monarchCyan,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Price Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.spotifyCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${product.price.toInt()} FCFA',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.monarchPurpleNeon,
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            if (product.originalPrice != null) ...[
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    '${product.originalPrice!.toInt()} FCFA',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.spotifyGrey,
                                      fontSize: 14,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (product.discountPercentage != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEF4444).withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        '-${product.discountPercentage}%',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xFFEF4444),
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ],
                        ),
                        const Spacer(),

                        // Quantity Selector
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.spotifyElevated,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, size: 16, color: Colors.white),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                onPressed: () {
                                  if (_quantity > 1) {
                                    setState(() => _quantity--);
                                  }
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  '$_quantity',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, size: 16, color: Colors.white),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                onPressed: () {
                                  if (_quantity < product.stock) {
                                    setState(() => _quantity++);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Trust Perks (Jumia / Alibaba style)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.spotifyCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                    ),
                    child: Column(
                      children: [
                        _buildPerkRow(Icons.local_shipping_outlined, 'Livraison Express Walliss', 'Reçu chez vous en 24h à 48h'),
                        const Divider(color: Colors.white10, height: 16),
                        _buildPerkRow(Icons.verified_user_outlined, 'Garantie Marchande 12 Mois', 'Échange ou remboursement certifié'),
                        const Divider(color: Colors.white10, height: 16),
                        _buildPerkRow(Icons.credit_card_outlined, 'Paiement Sécurisé Walliss', 'Protection des fonds jusqu\'à livraison'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Specifications Section
                  if (product.specs.isNotEmpty) ...[
                    Text(
                      'Caractéristiques Principales',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: product.specs.map((spec) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.spotifyElevated,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.monarchPurpleNeon.withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle_outline_rounded, size: 14, color: AppColors.monarchPurpleNeon),
                              const SizedBox(width: 6),
                              Text(
                                spec,
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Description
                  Text(
                    'Description du Produit',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.description,
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.spotifyGrey,
                      fontSize: 14,
                      height: 1.55,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Related Products Section
                  Text(
                    'Produits Similaires Recommandés',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),

                  allProductsAsync.when(
                    data: (products) {
                      final related = products.where((p) => p.id != product.id && p.category == product.category).toList();
                      final displayList = related.isNotEmpty ? related : products.where((p) => p.id != product.id).take(6).toList();

                      return SizedBox(
                        height: 170,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: displayList.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final item = displayList[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailPage(product: item),
                                  ),
                                );
                              },
                              child: Container(
                                width: 140,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.spotifyCard,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 70,
                                      decoration: BoxDecoration(
                                        color: AppColors.spotifyElevated,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          IconMapper.getIcon(item.icon),
                                          size: 32,
                                          color: AppColors.monarchPurpleNeon,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      item.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.plusJakartaSans(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '${item.price.toInt()} F',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: AppColors.monarchPurpleNeon,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // 3. Bottom Sticky Checkout / Add to Cart Bar
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        decoration: BoxDecoration(
          color: AppColors.spotifyCard,
          border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Add to cart button
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      for (int i = 0; i < _quantity; i++) {
                        ref.read(cartProvider.notifier).addToCart(product);
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '$_quantity x ${product.name} ajouté au panier',
                            style: GoogleFonts.plusJakartaSans(color: Colors.white),
                          ),
                          backgroundColor: AppColors.spotifyElevated,
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.monarchPurpleNeon),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      foregroundColor: Colors.white,
                    ),
                    child: const Icon(Icons.shopping_bag_outlined, color: AppColors.monarchPurpleNeon),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Buy Now button
              Expanded(
                flex: 3,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: AppColors.monarchGradient,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.monarchPurple.withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      for (int i = 0; i < _quantity; i++) {
                        ref.read(cartProvider.notifier).addToCart(product);
                      }
                      context.push(AppRoutes.cart);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      'Acheter (${(product.price * _quantity).toInt()} FCFA)',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerkRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.monarchPurpleNeon),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.spotifyGrey,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
