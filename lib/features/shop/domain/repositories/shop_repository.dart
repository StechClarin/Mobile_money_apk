import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/product.dart';

abstract class ShopRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, List<Product>>> getProductsByCategory(String category);
  Future<Either<Failure, List<String>>> getCategories();
}
