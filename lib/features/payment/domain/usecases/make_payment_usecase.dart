import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/payment_entity.dart';
import '../repositories/payment_repository.dart';

class MakePaymentUseCase implements UseCase<PaymentEntity, MakePaymentParams> {
  final PaymentRepository repository;

  MakePaymentUseCase(this.repository);

  @override
  Future<Either<Failure, PaymentEntity>> call(MakePaymentParams params) async {
    return await repository.makePayment(params.amount, params.recipient);
  }
}

class MakePaymentParams extends Equatable {
  final double amount;
  final String recipient;

  const MakePaymentParams({required this.amount, required this.recipient});

  @override
  List<Object> get props => [amount, recipient];
}
