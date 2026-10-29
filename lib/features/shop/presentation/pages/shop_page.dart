import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobilemoney/core/design_system/app_colors.dart';
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
      backgroundColor: AppColors.spotifyBlack,
      appBar: AppBar(
        backgroundColor: AppColors.spotifyBlack,
        elevation: 0,
        title: Text(
          'Boutique Walliss',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ShopSearchBar(),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Nos Équipements Pro',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
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
                        childAspectRatio: 0.58,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return ProductCard(
                          product: products[index],
                          onTap: () {},
                        );
                      },
                    ),
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.monarchPurpleNeon),
              ),
              error: (err, stack) => Center(
                child: Text('Erreur: $err', style: const TextStyle(color: Colors.redAccent)),
              ),
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
          const Icon(Icons.search_off_rounded, size: 60, color: AppColors.spotifyGrey),
          const SizedBox(height: 16),
          Text(
            'Aucun produit trouvé',
            style: GoogleFonts.plusJakartaSans(color: AppColors.spotifyGrey),
          ),
        ],
      ),
    );
  }
}

