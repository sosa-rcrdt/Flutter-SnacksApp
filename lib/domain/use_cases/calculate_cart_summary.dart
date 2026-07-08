import '../models/cart_summary.dart';
import '../models/product.dart';

abstract final class CalculateCartSummary {
  static CartSummary ejecutar({
    required List<Product> products,
    required Map<int, int> quantitiesByProduct,
  }) {
    var cantidadTotalProductos = 0;
    var totalCentavos = 0;

    for (final product in products) {
      final quantity = quantitiesByProduct[product.id] ?? 0;

      if (quantity <= 0) {
        continue;
      }

      cantidadTotalProductos += quantity;
      totalCentavos += product.precioCentavos * quantity;
    }

    return CartSummary(
      cantidadTotalProductos: cantidadTotalProductos,
      totalCentavos: totalCentavos,
    );
  }
}
