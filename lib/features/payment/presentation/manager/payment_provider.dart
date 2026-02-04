import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/usecases/make_payment_usecase.dart';
import '../../data/repositories/payment_repository_impl.dart';
import '../../data/datasources/payment_datasource.dart';
// Note: In a real app, you'd use a service locator or a provider for datasource/repo instantiated higher up.
// For this example, we mock/stub or assume they exist.

// Placeholder for DataSource provider
final paymentRemoteDataSourceProvider = Provider<PaymentRemoteDataSource>((ref) {
  throw UnimplementedError('RemoteDataSource not implemented yet');
});

final paymentRepositoryProvider = Provider((ref) {
  final dataSource = ref.watch(paymentRemoteDataSourceProvider);
  return PaymentRepositoryImpl(remoteDataSource: dataSource);
});

final makePaymentUseCaseProvider = Provider((ref) {
  final repository = ref.watch(paymentRepositoryProvider);
  return MakePaymentUseCase(repository);
});

// State definitions
abstract class PaymentState {}
class PaymentInitial extends PaymentState {}
class PaymentLoading extends PaymentState {}
class PaymentSuccess extends PaymentState {
  final PaymentEntity payment;
  PaymentSuccess(this.payment);
}
class PaymentError extends PaymentState {
  final String message;
  PaymentError(this.message);
}

class PaymentNotifier extends Notifier<PaymentState> {
  late final MakePaymentUseCase makePaymentUseCase;

  @override
  PaymentState build() {
    // In Riverpod 2.x Notifier, we can watch providers in build
    makePaymentUseCase = ref.watch(makePaymentUseCaseProvider);
    return PaymentInitial();
  }

  Future<void> makePayment(double amount, String recipient) async {
    state = PaymentLoading();
    final result = await makePaymentUseCase(MakePaymentParams(amount: amount, recipient: recipient));
    result.fold(
      (failure) => state = PaymentError('Payment Failed'),
      (payment) => state = PaymentSuccess(payment),
    );
  }
}

final paymentProvider = NotifierProvider<PaymentNotifier, PaymentState>(PaymentNotifier.new);
