import '../models/payment_model.dart';

abstract class PaymentRemoteDataSource {
  Future<PaymentModel> makePayment(double amount, String recipient);
  Future<List<PaymentModel>> getPaymentHistory();
}
