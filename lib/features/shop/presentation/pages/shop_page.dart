import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobilemoney/core/design_system/app_colors.dart';
import 'package:mobilemoney/core/design_system/app_text_styles.dart';
import 'package:mobilemoney/features/shop/presentation/manager/shop_providers.dart';
import 'package:mobilemoney/features/shop/presentation/widgets/category_tabs.dart';
import 'package:mobilemoney/features/shop/presentation/widgets/product_card.dart';
import 'package:mobilemoney/features/shop/presentation/widgets/shop_search_bar.dart';
import 'package:mobilemoney/core/constants.dart';

class ShopPage extends ConsumerWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final cartItemsCount = ref.watch(cartProvider).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Boutique My MoMo'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Badge(
              label: Text('$cartItemsCount'),
              isLabelVisible: cartItemsCount > 0,
              backgroundColor: AppColors.primary,
              textColor: AppColors.secondary,
              child: IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => context.push(AppRoutes.cart),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const ShopSearchBar(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Découvrez nos offres',
              style: AppTextStyles.h1,
            ),
          ),
          const SizedBox(height: 10),
          categoriesAsync.when(
            data: (categories) => CategoryTabs(
              categories: categories,
              selectedCategory: selectedCategory,
              onCategorySelected: (category) {
                ref.read(selectedCategoryProvider.notifier).state = category;
              },
            ),
            loading: () => const SizedBox(height: 40),
            error: (_, _) => const SizedBox(height: 40),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: productsAsync.when(
              data: (products) => products.isEmpty
                  ? _buildEmptySearch()
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return ProductCard(
                          product: products[index],
                          onTap: () {},
                        );
                      },
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Erreur: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySearch() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'Aucun produit trouvé',
            style: AppTextStyles.bodyLarge.copyWith(color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}
