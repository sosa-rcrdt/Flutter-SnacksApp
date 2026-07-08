import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../domain/models/sale_status.dart';
import 'dao/sales_dao.dart';
import 'entities/sale_details_table.dart';
import 'entities/sales_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Sales,
    SaleDetails,
  ],
  daos: [
    SalesDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase({
    QueryExecutor? executor,
  }) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;
}

QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'los_de_aca_snacks',
  );
}