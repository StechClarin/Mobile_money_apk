import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobilemoney/features/shop/presentation/manager/shop_providers.dart';
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
          SliverAppBar(
            backgroundColor: AppColors.spotifyBlack,
            leading: IconButton(
              icon: const Icon(Icons.menu_rounded, color: AppColors.monarchPurpleNeon),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            title: const Text(
              'Boutique Walliss',
              style: TextStyle(
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Boutique Officielle',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Équipements, terminaux et accessoires certifiés Walliss.',
                    style: TextStyle(color: AppColors.spotifyGrey, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  const ShopSearchBar(),
                  const SizedBox(height: 16),
                  const PromoCarousel(
                    banners: [
                      PromoBanner(id: 's1', imageUrl: 'url_shop_1', title: 'Pack Terminal Walliss POS -30%'),
                      PromoBanner(id: 's2', imageUrl: 'url_shop_2', title: 'Smartphones & Terminaux Pro'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              minHeight: 60.0,
              maxHeight: 60.0,
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: categoriesAsync.when(
                  data: (categories) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
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
          productsAsync.when(
            data: (products) => products.isEmpty
                ? const SliverFillRemaining(
                    child: Center(child: Text('Aucun produit trouvé')),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.55,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return ProductCard(
                            product: products[index],
                            onTap: () {},
                          );
                        },
                        childCount: products.length,
                      ),
                    ),
                  ),
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) => SliverFillRemaining(
              child: Center(child: Text('Erreur: $err')),
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
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
