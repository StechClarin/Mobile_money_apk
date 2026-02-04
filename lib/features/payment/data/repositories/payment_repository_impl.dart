import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_datasource.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PaymentEntity>> makePayment(double amount, String recipient) async {
    try {
      final payment = await remoteDataSource.makePayment(amount, recipient);
      return Right(payment);
    } catch (e) {
      return Left(ServerFailure()); // Simplified error handling
    }
  }

  @override
  Future<Either<Failure, List<PaymentEntity>>> getPaymentHistory() async {
    try {
      final payments = await remoteDataSource.getPaymentHistory();
      return Right(payments);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
