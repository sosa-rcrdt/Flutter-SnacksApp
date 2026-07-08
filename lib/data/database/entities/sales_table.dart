import 'package:drift/drift.dart';

import '../../../domain/models/sale_status.dart';

@DataClassName('SaleEntity')
class Sales extends Table {
  @override
  String get tableName => 'sales';

  IntColumn get id => integer().autoIncrement()();

  DateTimeColumn get fechaHora => dateTime().named('fecha_hora')();

  IntColumn get totalCentavos => integer().named('total_centavos')();

  IntColumn get dineroRecibidoCentavos =>
      integer().named('dinero_recibido_centavos')();

  IntColumn get cambioCentavos => integer().named('cambio_centavos')();

  TextColumn get estado => textEnum<SaleStatus>().named('estado')();
}
