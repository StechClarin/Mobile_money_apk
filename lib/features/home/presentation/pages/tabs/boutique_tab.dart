import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobilemoney/features/shop/presentation/manager/shop_providers.dart';
import 'package:mobilemoney/features/shop/presentation/widgets/category_tabs.dart';
import 'package:mobilemoney/features/shop/presentation/widgets/product_card.dart';
import 'package:mobilemoney/features/shop/presentation/widgets/shop_search_bar.dart';
import 'package:mobilemoney/core/design_system/app_text_styles.dart';
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
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: const Icon(Icons.menu, color: AppColors.secondary),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            title: const Text(
              '677 00 00 00',
              style: TextStyle(
                color: AppColors.secondary,
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
                  backgroundColor: Colors.white,
                  textColor: AppColors.primary,
                  child: IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.secondary),
                    onPressed: () => context.push(AppRoutes.cart),
                  ),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Exclusive pour vous',
                    style: AppTextStyles.h1,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Trouvez les meilleures offres et services MTN.',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey),
                  ),
                  const SizedBox(height: 16),
                  const ShopSearchBar(),
                  const SizedBox(height: 16),
                  const PromoCarousel(
                    banners: [
                      PromoBanner(id: 's1', imageUrl: 'url_shop_1', title: 'Soldes d\'Été -50%'),
                      PromoBanner(id: 's2', imageUrl: 'url_shop_2', title: 'Nouveaux Smartphones Dispo'),
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
