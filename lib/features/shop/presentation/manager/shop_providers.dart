import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/shop_repository_impl.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/shop_repository.dart';
import '../../domain/usecases/get_products.dart';

// Repository Provider
final shopRepositoryProvider = Provider<ShopRepository>((ref) {
  return ShopRepositoryImpl();
});

// UseCase Provider
final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  return GetProductsUseCase(ref.watch(shopRepositoryProvider));
});

// Search Query Provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Products Provider
final productsProvider = AsyncNotifierProvider<ProductsNotifier, List<Product>>(() {
  return ProductsNotifier();
});

class ProductsNotifier extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() async {
    final useCase = ref.watch(getProductsUseCaseProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    final result = await useCase.execute();
    return result.fold(
      (failure) => throw Exception('Failed to fetch products'),
      (products) {
        return products.where((product) {
          final matchesCategory = selectedCategory == 'All' || product.category == selectedCategory;
          final matchesSearch = product.name.toLowerCase().contains(searchQuery.toLowerCase());
          return matchesCategory && matchesSearch;
        }).toList();
      },
    );
  }

  // filterByCategory and search logic are now reactive via the build method
}

// Categories Provider
final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(shopRepositoryProvider);
  final result = await repository.getCategories();
  return result.fold(
    (failure) => ['All'],
    (categories) => categories,
  );
});

// Selected Category Provider
final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

// Cart Provider
final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(() {
  return CartNotifier();
});

class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() => [];

  void addToCart(Product product) {
    final existingIndex = state.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == existingIndex)
            state[i].copyWith(quantity: state[i].quantity + 1)
          else
            state[i]
      ];
    } else {
      state = [...state, CartItem(product: product, quantity: 1)];
    }
  }

  void removeFromCart(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }
    state = [
      for (final item in state)
        if (item.product.id == productId)
          item.copyWith(quantity: quantity)
        else
          item
    ];
  }

  void clearCart() {
    state = [];
  }

  double get totalCartPrice => state.fold(0, (sum, item) => sum + item.totalPrice);
  int get itemCount => state.fold(0, (sum, item) => sum + item.quantity);
}

// Wishlist Provider
final wishlistProvider = NotifierProvider<WishlistNotifier, List<String>>(() {
  return WishlistNotifier();
});

class WishlistNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => [];

  void toggleFavorite(String productId) {
    if (state.contains(productId)) {
      state = state.where((id) => id != productId).toList();
    } else {
      state = [...state, productId];
    }
  }

  bool isFavorite(String productId) => state.contains(productId);
}
