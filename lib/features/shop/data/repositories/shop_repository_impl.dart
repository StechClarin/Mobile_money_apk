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
        name: 'Terminal Walliss POS Pro',
        description: 'Terminal tactile avec imprimante thermique pour marchands.',
        price: 85000,
        imageUrl: 'https://placeholder.com/150',
        category: 'Terminaux',
        icon: 'point_of_sale',
      ),
      const Product(
        id: '2',
        name: 'Smart T Walliss 4G',
        description: 'Smartphone professionnel sécurisé avec application Walliss pré-installée.',
        price: 25000,
        imageUrl: 'https://placeholder.com/150',
        category: 'Telephones',
        icon: 'phone_android',
      ),
      const Product(
        id: '3',
        name: 'Lecteur QR & Carte NFC',
        description: 'Boîtier d\'encaissement ultra-rapide pour points de vente.',
        price: 18000,
        imageUrl: 'https://placeholder.com/150',
        category: 'Terminaux',
        icon: 'nfc',
      ),
      const Product(
        id: '4',
        name: 'Walliss Box WiFi 5G',
        description: 'Routeur haut débit autonome pour commerces et domiciles.',
        price: 35000,
        imageUrl: 'https://placeholder.com/150',
        category: 'Routers',
        icon: 'wifi',
      ),
      const Product(
        id: '5',
        name: 'iPhone 15 Pro Max',
        description: 'L\'expérience ultime pour piloter votre entreprise Walliss.',
        price: 890000,
        imageUrl: 'https://placeholder.com/150',
        category: 'Telephones',
        icon: 'smartphone',
      ),
      const Product(
        id: '6',
        name: 'Badge Paiement Walliss NFC',
        description: 'Porte-clé sécurisé pour payer d\'un simple geste.',
        price: 5000,
        imageUrl: 'https://placeholder.com/150',
        category: 'Accessoires',
        icon: 'contactless',
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
    return const Right(['All', 'Terminaux', 'Telephones', 'Routers', 'Accessoires']);
  }
}
