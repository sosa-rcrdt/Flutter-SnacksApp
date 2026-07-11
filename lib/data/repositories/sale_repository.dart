import 'package:drift/drift.dart';

import '../../domain/models/cart_summary.dart';
import '../../domain/models/payment_summary.dart';
import '../../domain/models/product.dart';
import '../../domain/models/sale.dart';
import '../../domain/models/sale_detail.dart';
import '../../domain/models/sale_status.dart';
import '../database/app_database.dart';

class SaleRepository {
  final AppDatabase _database;

  const SaleRepository(this._database);

  Future<int> guardarVentaCompletada({
    required List<Product> productos,
    required Map<int, int> cantidadesPorProducto,
    required CartSummary resumenCarrito,
    required PaymentSummary resumenCobro,
  }) async {
    if (resumenCarrito.estaVacio) {
      throw StateError('No se puede guardar una venta sin productos.');
    }

    if (!resumenCobro.pagoSuficiente) {
      throw StateError('No se puede guardar una venta con pago insuficiente.');
    }

    final detalles = _crearDetallesVenta(
      productos: productos,
      cantidadesPorProducto: cantidadesPorProducto,
    );

    if (detalles.isEmpty) {
      throw StateError('No se pudo generar el detalle de la venta.');
    }

    final cantidadCalculada = detalles.fold<int>(
      0,
      (total, detalle) => total + detalle.cantidad.value,
    );

    final totalCalculado = detalles.fold<int>(
      0,
      (total, detalle) => total + detalle.subtotalCentavos.value,
    );

    if (cantidadCalculada != resumenCarrito.cantidadTotalProductos) {
      throw StateError(
        'La cantidad del detalle no coincide con el resumen del carrito.',
      );
    }

    if (totalCalculado != resumenCarrito.totalCentavos) {
      throw StateError(
        'El total del detalle no coincide con el resumen del carrito.',
      );
    }

    final venta = SalesCompanion.insert(
      fechaHora: DateTime.now(),
      totalCentavos: resumenCarrito.totalCentavos,
      dineroRecibidoCentavos: resumenCobro.dineroRecibidoCentavos!,
      cambioCentavos: resumenCobro.cambioCentavos,
      estado: SaleStatus.completada,
    );

    return _database.salesDao.insertSaleWithDetails(
      sale: venta,
      details: detalles,
    );
  }

  Future<Sale?> obtenerVentaPorId(int ventaId) async {
    final venta = await _database.salesDao.getSaleById(ventaId);

    if (venta == null) {
      return null;
    }

    return _mapSaleEntityToDomain(venta);
  }

  Future<List<SaleDetail>> obtenerDetallesDeVenta(int ventaId) async {
    final detalles = await _database.salesDao.getSaleDetailsBySaleId(ventaId);

    return detalles.map(_mapSaleDetailEntityToDomain).toList();
  }

  Future<List<SaleDetail>> obtenerDetallesDeVentas(List<int> ventaIds) async {
    if (ventaIds.isEmpty) {
      return const <SaleDetail>[];
    }

    final detallesPorVenta = await Future.wait(
      ventaIds.map(obtenerDetallesDeVenta),
    );

    return detallesPorVenta.expand((detalles) => detalles).toList();
  }

  Future<List<Sale>> obtenerVentasEntre({
    required DateTime inicio,
    required DateTime fin,
  }) async {
    final ventas = await _database.salesDao.getSalesBetween(
      start: inicio,
      end: fin,
    );

    return ventas.map(_mapSaleEntityToDomain).toList();
  }

  Future<List<Sale>> obtenerVentasDelDia(DateTime dia) {
    final inicioDelDia = DateTime(dia.year, dia.month, dia.day);

    final inicioDelDiaSiguiente = inicioDelDia.add(const Duration(days: 1));

    return obtenerVentasEntre(inicio: inicioDelDia, fin: inicioDelDiaSiguiente);
  }

  Future<void> cancelarVenta(int ventaId) {
    return _database.salesDao.cancelSale(ventaId);
  }

  List<SaleDetailsCompanion> _crearDetallesVenta({
    required List<Product> productos,
    required Map<int, int> cantidadesPorProducto,
  }) {
    final detalles = <SaleDetailsCompanion>[];

    for (final producto in productos) {
      final cantidad = cantidadesPorProducto[producto.id] ?? 0;

      if (cantidad <= 0) {
        continue;
      }

      final subtotalCentavos = producto.precioCentavos * cantidad;

      detalles.add(
        SaleDetailsCompanion(
          ventaId: const Value.absent(),
          productoId: Value(producto.id),
          nombreProductoSnapshot: Value(producto.nombre),
          precioUnitarioCentavosSnapshot: Value(producto.precioCentavos),
          cantidad: Value(cantidad),
          subtotalCentavos: Value(subtotalCentavos),
        ),
      );
    }

    return detalles;
  }

  Sale _mapSaleEntityToDomain(SaleEntity entity) {
    return Sale(
      id: entity.id,
      fechaHora: entity.fechaHora,
      totalCentavos: entity.totalCentavos,
      dineroRecibidoCentavos: entity.dineroRecibidoCentavos,
      cambioCentavos: entity.cambioCentavos,
      estado: entity.estado,
    );
  }

  SaleDetail _mapSaleDetailEntityToDomain(SaleDetailEntity entity) {
    return SaleDetail(
      id: entity.id,
      ventaId: entity.ventaId,
      productoId: entity.productoId,
      nombreProductoSnapshot: entity.nombreProductoSnapshot,
      precioUnitarioCentavosSnapshot: entity.precioUnitarioCentavosSnapshot,
      cantidad: entity.cantidad,
      subtotalCentavos: entity.subtotalCentavos,
    );
  }
}
