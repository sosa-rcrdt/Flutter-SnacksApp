import '../../core/format/money_format.dart';
import '../models/cart_summary.dart';
import '../models/payment_summary.dart';
import '../models/payment_validation_message.dart';

abstract final class CalculatePaymentValidationMessage {
  static PaymentValidationMessage ejecutar({
    required String textoDineroRecibido,
    required CartSummary cartSummary,
    required PaymentSummary paymentSummary,
  }) {
    if (cartSummary.estaVacio) {
      return const PaymentValidationMessage(
        titulo: 'No hay productos',
        descripcion: 'Agrega productos antes de confirmar una venta.',
        tipo: PaymentValidationType.warning,
      );
    }

    if (textoDineroRecibido.trim().isEmpty) {
      return const PaymentValidationMessage(
        titulo: 'Cantidad pendiente',
        descripcion: 'Ingresa el dinero recibido para calcular el cambio.',
        tipo: PaymentValidationType.warning,
      );
    }

    if (!paymentSummary.dineroRecibidoValido) {
      return const PaymentValidationMessage(
        titulo: 'Cantidad no válida',
        descripcion:
            'Usa solo números y máximo dos decimales. Ejemplo: 150 o 150.50.',
        tipo: PaymentValidationType.error,
      );
    }

    if (!paymentSummary.pagoSuficiente) {
      return PaymentValidationMessage(
        titulo: 'Pago insuficiente',
        descripcion:
            'Faltan ${formatearCentavosComoPesos(paymentSummary.faltanteCentavos)} para completar el pago.',
        tipo: PaymentValidationType.error,
      );
    }

    if (paymentSummary.pagoExacto) {
      return const PaymentValidationMessage(
        titulo: 'Pago exacto',
        descripcion:
            'El cliente entregó la cantidad exacta. Puedes confirmar la venta.',
        tipo: PaymentValidationType.success,
      );
    }

    return PaymentValidationMessage(
      titulo: 'Pago suficiente',
      descripcion:
          'Entrega ${formatearCentavosComoPesos(paymentSummary.cambioCentavos)} de cambio al cliente.',
      tipo: PaymentValidationType.success,
    );
  }
}
