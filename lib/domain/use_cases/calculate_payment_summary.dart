import '../models/cart_summary.dart';
import '../models/payment_summary.dart';

abstract final class CalculatePaymentSummary {
  static PaymentSummary ejecutar({
    required CartSummary cartSummary,
    required int? dineroRecibidoCentavos,
  }) {
    return PaymentSummary(
      totalCentavos: cartSummary.totalCentavos,
      dineroRecibidoCentavos: dineroRecibidoCentavos,
    );
  }
}