import 'package:drift/drift.dart';

import 'sales_table.dart';

@DataClassName('SaleDetailEntity')
class SaleDetails extends Table {
  @override
  String get tableName => 'sale_details';

  IntColumn get id => integer().autoIncrement()();

  IntColumn get ventaId => integer()
      .named('venta_id')
      .references(
        Sales,
        #id,
        onDelete: KeyAction.cascade,
      )();

  IntColumn get productoId => integer().named('producto_id')();

  TextColumn get nombreProductoSnapshot =>
      text().named('nombre_producto_snapshot')();

  IntColumn get precioUnitarioCentavosSnapshot =>
      integer().named('precio_unitario_centavos_snapshot')();

  IntColumn get cantidad => integer().named('cantidad')();

  IntColumn get subtotalCentavos => integer().named('subtotal_centavos')();
}