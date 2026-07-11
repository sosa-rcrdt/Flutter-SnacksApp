import '../models/daily_product_sales_insights.dart';
import '../models/product_sales_insight.dart';
import '../models/sale_detail.dart';

abstract final class CalculateDailyProductSalesInsights {
  static DailyProductSalesInsights ejecutar({
    required List<SaleDetail> detalles,
  }) {
    if (detalles.isEmpty) {
      return DailyProductSalesInsights.empty;
    }

    final productosAgrupados = <int, ProductSalesInsight>{};

    for (final detalle in detalles) {
      final productoExistente = productosAgrupados[detalle.productoId];

      if (productoExistente == null) {
        productosAgrupados[detalle.productoId] = ProductSalesInsight(
          productoId: detalle.productoId,
          nombreProductoSnapshot: detalle.nombreProductoSnapshot,
          unidadesVendidas: detalle.cantidad,
          ingresoCentavos: detalle.subtotalCentavos,
        );
        continue;
      }

      productosAgrupados[detalle.productoId] = productoExistente.copyWith(
        unidadesVendidas: productoExistente.unidadesVendidas + detalle.cantidad,
        ingresoCentavos:
            productoExistente.ingresoCentavos + detalle.subtotalCentavos,
      );
    }

    final productos = productosAgrupados.values.toList()
      ..sort((a, b) {
        final comparacionUnidades = b.unidadesVendidas.compareTo(
          a.unidadesVendidas,
        );

        if (comparacionUnidades != 0) {
          return comparacionUnidades;
        }

        return b.ingresoCentavos.compareTo(a.ingresoCentavos);
      });

    return DailyProductSalesInsights(productos: List.unmodifiable(productos));
  }
}
