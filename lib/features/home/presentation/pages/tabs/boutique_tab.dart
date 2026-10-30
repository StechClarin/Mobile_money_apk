import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobilemoney/features/shop/domain/entities/product.dart';
import 'package:mobilemoney/features/shop/presentation/manager/shop_providers.dart';
import 'package:mobilemoney/features/shop/presentation/utils/icon_mapper.dart';
import 'package:mobilemoney/features/shop/presentation/widgets/category_tabs.dart';
import 'package:mobilemoney/features/shop/presentation/widgets/product_card.dart';
import 'package:mobilemoney/features/shop/presentation/widgets/shop_search_bar.dart';
import 'package:mobilemoney/core/design_system/app_colors.dart';
import 'package:mobilemoney/core/constants.dart';
import '../../widgets/promo_carousel.dart';
import '../../../domain/entities/promo_banner.dart';

class BoutiqueTab extends ConsumerWidget {
  const BoutiqueTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final cartItemsCount = ref.watch(cartProvider).length;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        key: const PageStorageKey('BoutiqueTab'),
        slivers: [
          // 1. Top Navigation Bar
          SliverAppBar(
            backgroundColor: AppColors.spotifyBlack,
            leading: IconButton(
              icon: const Icon(Icons.menu_rounded, color: AppColors.monarchPurpleNeon),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            title: Text(
              'Boutique Walliss',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            floating: true,
            pinned: true,
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Badge(
                  label: Text('$cartItemsCount'),
                  isLabelVisible: cartItemsCount > 0,
                  backgroundColor: AppColors.monarchPurpleNeon,
                  textColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                    onPressed: () => context.push(AppRoutes.cart),
                  ),
                ),
              ),
            ],
          ),

          // 2. Official Header + Search + Promo Carousel
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Walliss Store Pro',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.monarchPurpleNeon.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.monarchPurpleNeon.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          'OFFICIEL',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.monarchPurpleNeon,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Le plus grand catalogue d\'équipements, terminaux et tech certifiés.',
                    style: GoogleFonts.plusJakartaSans(color: AppColors.spotifyGrey, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  const ShopSearchBar(),
                  const SizedBox(height: 16),
                  const PromoCarousel(
                    banners: [
                      PromoBanner(id: 's1', imageUrl: 'url_shop_1', title: 'Pack Terminal Walliss POS -30%'),
                      PromoBanner(id: 's2', imageUrl: 'url_shop_2', title: 'Smartphones & Terminaux Pro'),
                      PromoBanner(id: 's3', imageUrl: 'url_shop_3', title: 'Routeurs 5G & Réseau -25%'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 3. Sticky Categories Bar
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              minHeight: 54.0,
              maxHeight: 54.0,
              child: Container(
                color: AppColors.spotifyBlack,
                child: categoriesAsync.when(
                  data: (categories) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: CategoryTabs(
                      categories: categories,
                      selectedCategory: selectedCategory,
                      onCategorySelected: (category) {
                        ref.read(selectedCategoryProvider.notifier).state = category;
                      },
                    ),
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
              ),
            ),
          ),

          // 4. Products Catalog with Masonry Irregular Heights & Mid-Scroll Ads/Horizontal Carousels
          productsAsync.when(
            data: (products) {
              if (products.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'Aucun produit trouvé dans cette catégorie',
                      style: GoogleFonts.plusJakartaSans(color: AppColors.spotifyGrey),
                    ),
                  ),
                );
              }

              // When user filters by category or searches, render pure Masonry Grid with irregular heights
              final searchQuery = ref.watch(searchQueryProvider);
              if (selectedCategory != 'All' || searchQuery.isNotEmpty) {
                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  sliver: SliverMasonryGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    itemBuilder: (context, index) {
                      return ProductCard(product: products[index]);
                    },
                    childCount: products.length,
                  ),
                );
              }

              // For the massive Jumia/Alibaba store ("All" view):
              // Split into staggered batches interleaved with horizontal promo carousels and ad banners!
              final batch1 = products.take(6).toList();
              final flashSales = products.where((p) => p.discountPercentage != null && p.discountPercentage! >= 20).toList();
              final batch2 = products.skip(6).take(8).toList();
              final topTech = products.where((p) => p.category == 'Smartphones' || p.category == 'Ordinateurs & Tablettes').toList();
              final batch3 = products.skip(14).toList();

              return SliverMainAxisGroup(
                slivers: [
                  // --- SECTION 1: Staggered Masonry Batch 1 ---
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    sliver: SliverMasonryGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      itemBuilder: (context, index) {
                        return ProductCard(product: batch1[index]);
                      },
                      childCount: batch1.length,
                    ),
                  ),

                  // --- SECTION 2: Mid-Scroll Banner + Left-to-Right Horizontal Scrolling Products ---
                  SliverToBoxAdapter(
                    child: _buildMidScrollFlashSaleSection(context, flashSales),
                  ),

                  // --- SECTION 3: Mid-Scroll Commercial Ad Banner (Alibaba / Jumia Style) ---
                  SliverToBoxAdapter(
                    child: _buildCommercialPartnerBanner(context),
                  ),

                  // --- SECTION 4: Section Title + Staggered Masonry Batch 2 ---
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Row(
                        children: [
                          Container(
                            width: 4,
                            height: 18,
                            decoration: BoxDecoration(
                              color: AppColors.monarchPurpleNeon,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '🔥 Tendances & Meilleurs Équipements',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    sliver: SliverMasonryGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      itemBuilder: (context, index) {
                        return ProductCard(product: batch2[index]);
                      },
                      childCount: batch2.length,
                    ),
                  ),

                  // --- SECTION 5: Second Left-to-Right Horizontal Showcase (Top Tech Devices) ---
                  if (topTech.isNotEmpty)
                    SliverToBoxAdapter(
                      child: _buildHorizontalTechShowcase(context, topTech),
                    ),

                  // --- SECTION 6: Remaining Products Staggered Masonry ---
                  if (batch3.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              height: 18,
                              decoration: BoxDecoration(
                                color: AppColors.monarchCyan,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '📦 Tout le Catalogue Certifié Walliss',
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 30),
                      sliver: SliverMasonryGrid.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        itemBuilder: (context, index) {
                          return ProductCard(product: batch3[index]);
                        },
                        childCount: batch3.length,
                      ),
                    ),
                  ],
                ],
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.monarchPurpleNeon),
              ),
            ),
            error: (err, stack) => SliverFillRemaining(
              child: Center(
                child: Text('Erreur: $err', style: const TextStyle(color: Colors.redAccent)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Horizontal Left-to-Right Flash Sale Section
  Widget _buildMidScrollFlashSaleSection(BuildContext context, List<Product> flashSales) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF161026),
        border: Border.symmetric(
          horizontal: BorderSide(color: AppColors.monarchPurpleNeon.withValues(alpha: 0.25)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Top Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bolt_rounded, color: Color(0xFFF59E0B), size: 22),
                    const SizedBox(width: 6),
                    Text(
                      'VENTES FLASH EXCLUSIVES',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 12, color: Color(0xFFEF4444)),
                      const SizedBox(width: 4),
                      Text(
                        '03:45:18',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFFEF4444),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Horizontal Scrolling Products (Left to Right, Clickable)
          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: flashSales.length,
              separatorBuilder: (context, index) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final product = flashSales[index];
                return GestureDetector(
                  onTap: () {
                    context.push(AppRoutes.productDetail, extra: product);
                  },
                  child: Container(
                    width: 155,
                    decoration: BoxDecoration(
                      color: AppColors.spotifyCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.spotifyElevated,
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              ),
                              child: Center(
                                child: Icon(
                                  IconMapper.getIcon(product.icon),
                                  size: 40,
                                  color: AppColors.monarchPurpleNeon,
                                ),
                              ),
                            ),
                            if (product.discountPercentage != null)
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEF4444),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '-${product.discountPercentage}%',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${product.price.toInt()} F',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.monarchPurpleNeon,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              if (product.originalPrice != null)
                                Text(
                                  '${product.originalPrice!.toInt()} F',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.spotifySubtle,
                                    fontSize: 10,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                            ],
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

  // Commercial / Partner Promotion Ad Banner
  Widget _buildCommercialPartnerBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF2C1052),
              Color(0xFF140728),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: AppColors.monarchPurpleNeon.withValues(alpha: 0.35)),
          boxShadow: [
            BoxShadow(
              color: AppColors.monarchPurple.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.monarchPurpleNeon,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'OFFRE MARCHANDE EXCLUSIVE',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Passez au Terminal Walliss Pro 5G',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '0% de frais d\'encaissement le 1er mois & garantie échange 24h.',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.spotifyGrey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.spotifyElevated,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.monarchPurpleNeon.withValues(alpha: 0.4)),
              ),
              child: const Icon(Icons.point_of_sale_rounded, color: AppColors.monarchPurpleNeon, size: 28),
            ),
          ],
        ),
      ),
    );
  }

  // Second Horizontal Tech Showcase (Left-to-Right)
  Widget _buildHorizontalTechShowcase(BuildContext context, List<Product> techProducts) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.devices_rounded, color: AppColors.monarchCyan, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Smartphones & Ordinateurs Pro',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Défiler >',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.spotifyGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: techProducts.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final product = techProducts[index];
                return GestureDetector(
                  onTap: () {
                    context.push(AppRoutes.productDetail, extra: product);
                  },
                  child: Container(
                    width: 220,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.spotifyCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 75,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.spotifyElevated,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Icon(
                              IconMapper.getIcon(product.icon),
                              size: 36,
                              color: AppColors.monarchCyan,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                product.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${product.price.toInt()} F',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.monarchPurpleNeon,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded, size: 12, color: Color(0xFFF59E0B)),
                                  const SizedBox(width: 2),
                                  Text(
                                    product.rating.toStringAsFixed(1),
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.spotifyGrey,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
