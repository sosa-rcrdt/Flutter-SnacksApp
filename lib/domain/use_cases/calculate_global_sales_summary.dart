import '../models/global_sales_summary.dart';
import '../models/sale.dart';
import '../models/sale_status.dart';

abstract final class CalculateGlobalSalesSummary {
  static GlobalSalesSummary ejecutar({
    required DateTime inicio,
    required DateTime finExclusivo,
    required List<Sale> ventas,
  }) {
    var ventasCompletadas = 0;
    var ventasCanceladas = 0;
    var totalVendidoCentavos = 0;

    for (final venta in ventas) {
      switch (venta.estado) {
        case SaleStatus.completada:
          ventasCompletadas++;
          totalVendidoCentavos += venta.totalCentavos;

        case SaleStatus.cancelada:
          ventasCanceladas++;
      }
    }

    return GlobalSalesSummary(
      inicio: inicio,
      finExclusivo: finExclusivo,
      totalVentas: ventas.length,
      ventasCompletadas: ventasCompletadas,
      ventasCanceladas: ventasCanceladas,
      totalVendidoCentavos: totalVendidoCentavos,
    );
  }
}
