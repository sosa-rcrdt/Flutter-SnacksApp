import '../models/daily_sales_summary.dart';
import '../models/sale.dart';
import '../models/sale_status.dart';

abstract final class CalculateDailySalesSummary {
  static DailySalesSummary ejecutar({
    required DateTime fecha,
    required List<Sale> ventas,
  }) {
    var ventasCompletadas = 0;
    var ventasCanceladas = 0;
    var totalVendidoCentavos = 0;
    var totalRecibidoCentavos = 0;
    var totalCambioCentavos = 0;

    for (final venta in ventas) {
      switch (venta.estado) {
        case SaleStatus.completada:
          ventasCompletadas++;
          totalVendidoCentavos += venta.totalCentavos;
          totalRecibidoCentavos += venta.dineroRecibidoCentavos;
          totalCambioCentavos += venta.cambioCentavos;

        case SaleStatus.cancelada:
          ventasCanceladas++;
      }
    }

    return DailySalesSummary(
      fecha: DateTime(fecha.year, fecha.month, fecha.day),
      totalVentas: ventas.length,
      ventasCompletadas: ventasCompletadas,
      ventasCanceladas: ventasCanceladas,
      totalVendidoCentavos: totalVendidoCentavos,
      totalRecibidoCentavos: totalRecibidoCentavos,
      totalCambioCentavos: totalCambioCentavos,
    );
  }
}
