import 'package:drift/drift.dart';

import '../../../domain/models/sale_status.dart';
import '../app_database.dart';
import '../entities/sale_details_table.dart';
import '../entities/sales_table.dart';

part 'sales_dao.g.dart';

@DriftAccessor(
  tables: [
    Sales,
    SaleDetails,
  ],
)
class SalesDao extends DatabaseAccessor<AppDatabase> with _$SalesDaoMixin {
  SalesDao(super.db);

  Future<int> insertSale(SalesCompanion sale) {
    return into(sales).insert(sale);
  }

  Future<void> insertSaleDetails(List<SaleDetailsCompanion> details) async {
    if (details.isEmpty) {
      return;
    }

    await batch((batch) {
      batch.insertAll(saleDetails, details);
    });
  }

  Future<int> insertSaleWithDetails({
    required SalesCompanion sale,
    required List<SaleDetailsCompanion> details,
  }) {
    return transaction(() async {
      final saleId = await insertSale(sale);

      final detailsWithSaleId = details.map((detail) {
        return detail.copyWith(
          ventaId: Value(saleId),
        );
      }).toList();

      await insertSaleDetails(detailsWithSaleId);

      return saleId;
    });
  }

  Future<SaleEntity?> getSaleById(int saleId) {
    final query = select(sales)
      ..where(
        (sale) => sale.id.equals(saleId),
      );

    return query.getSingleOrNull();
  }

  Future<List<SaleDetailEntity>> getSaleDetailsBySaleId(int saleId) {
    final query = select(saleDetails)
      ..where(
        (detail) => detail.ventaId.equals(saleId),
      )
      ..orderBy([
        (detail) => OrderingTerm.asc(detail.id),
      ]);

    return query.get();
  }

  Future<List<SaleEntity>> getSalesBetween({
    required DateTime start,
    required DateTime end,
  }) {
    final query = select(sales)
      ..where(
        (sale) => sale.fechaHora.isBetweenValues(start, end),
      )
      ..orderBy([
        (sale) => OrderingTerm.desc(sale.fechaHora),
      ]);

    return query.get();
  }

  Future<void> cancelSale(int saleId) {
    final query = update(sales)
      ..where(
        (sale) => sale.id.equals(saleId),
      );

    return query.write(
      const SalesCompanion(
        estado: Value(SaleStatus.cancelada),
      ),
    );
  }
}