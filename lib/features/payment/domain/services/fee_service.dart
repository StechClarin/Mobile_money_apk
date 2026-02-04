class FeeService {
  static const double _feeRate = 0.01; // 1% fee

  /// Calculates the total amount to be deducted (Amount + Fees)
  /// based on the net amount the receiver should get.
  /// Total = Net * (1 + fee)
  double calculateTotalFromNet(double netAmount) {
    if (netAmount <= 0) return 0;
    return netAmount * (1 + _feeRate);
  }

  /// Calculates the net amount the receiver gets
  /// based on the total amount deducted.
  /// Net = Total / (1 + fee)
  double calculateNetFromTotal(double totalAmount) {
    if (totalAmount <= 0) return 0;
    return totalAmount / (1 + _feeRate);
  }

  /// Calculates the fee amount from the total amount.
  double calculateFeeFromTotal(double totalAmount) {
    if (totalAmount <= 0) return 0;
    double net = calculateNetFromTotal(totalAmount);
    return totalAmount - net;
  }
}
