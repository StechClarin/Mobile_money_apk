import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/shop_repository.dart';

class ShopRepositoryImpl implements ShopRepository {
  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    // Mock data for now as per plan
    final mockProducts = [
      const Product(
        id: '1',
        name: 'MTN Smart T',
        description: 'Le smartphone 3G abordable avec WhatsApp intégré.',
        price: 15500,
        imageUrl: 'https://placeholder.com/150',
        category: 'Telephones',
        icon: 'phone_android',
      ),
      const Product(
        id: '2',
        name: 'Flybox 4G MTN',
        description: 'Internet à la maison pour toute la famille.',
        price: 25000,
        imageUrl: 'https://placeholder.com/150',
        category: 'Flybox',
        icon: 'wifi',
      ),
      const Product(
        id: '3',
        name: 'Routeur Fixe 4G',
        description: 'Connexion haut débit stable pour bureau.',
        price: 35000,
        imageUrl: 'https://placeholder.com/150',
        category: 'Routers',
        icon: 'router',
      ),
      const Product(
        id: '4',
        name: 'TV Box MTN',
        description: 'Accédez à toutes vos chaînes préférées en HD.',
        price: 45000,
        imageUrl: 'https://placeholder.com/150',
        category: 'TV',
        icon: 'tv',
      ),
      const Product(
        id: '5',
        name: 'Modem USB 4G',
        description: 'Vivez la mobilité avec internet partout.',
        price: 10000,
        imageUrl: 'https://placeholder.com/150',
        category: 'Modems',
        icon: 'usb',
      ),
       const Product(
        id: '6',
        name: 'iPhone 15 Pro MTN',
        description: 'L\'expérience ultime avec le réseau MTN 4G+.',
        price: 850000,
        imageUrl: 'https://placeholder.com/150',
        category: 'Telephones',
        icon: 'smartphone',
      ),
    ];
    return Right(mockProducts);
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory(String category) async {
    final result = await getProducts();
    return result.fold(
      (failure) => Left(failure),
      (products) => Right(products.where((p) => p.category == category).toList()),
    );
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    return const Right(['All', 'Telephones', 'Routers', 'Flybox', 'TV', 'Modems']);
  }
}
