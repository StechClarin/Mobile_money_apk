import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/product.dart';
import '../repositories/shop_repository.dart';

class GetProductsUseCase {
  final ShopRepository repository;

  GetProductsUseCase(this.repository);

  Future<Either<Failure, List<Product>>> execute() async {
    return await repository.getProducts();
  }
}
