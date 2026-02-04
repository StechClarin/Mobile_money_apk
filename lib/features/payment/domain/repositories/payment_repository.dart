import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/payment_entity.dart';

abstract class PaymentRepository {
  Future<Either<Failure, PaymentEntity>> makePayment(double amount, String recipient);
  Future<Either<Failure, List<PaymentEntity>>> getPaymentHistory();
}
