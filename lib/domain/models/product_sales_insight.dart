class ProductSalesInsight {
  final int productoId;
  final String nombreProductoSnapshot;
  final int unidadesVendidas;
  final int ingresoCentavos;

  const ProductSalesInsight({
    required this.productoId,
    required this.nombreProductoSnapshot,
    required this.unidadesVendidas,
    required this.ingresoCentavos,
  }) : assert(productoId > 0, 'El id del producto debe ser mayor que 0.'),
       assert(
         unidadesVendidas >= 0,
         'Las unidades vendidas no pueden ser negativas.',
       ),
       assert(ingresoCentavos >= 0, 'El ingreso no puede ser negativo.');

  ProductSalesInsight copyWith({
    int? productoId,
    String? nombreProductoSnapshot,
    int? unidadesVendidas,
    int? ingresoCentavos,
  }) {
    return ProductSalesInsight(
      productoId: productoId ?? this.productoId,
      nombreProductoSnapshot:
          nombreProductoSnapshot ?? this.nombreProductoSnapshot,
      unidadesVendidas: unidadesVendidas ?? this.unidadesVendidas,
      ingresoCentavos: ingresoCentavos ?? this.ingresoCentavos,
    );
  }

  @override
  String toString() {
    return 'ProductSalesInsight('
        'productoId: $productoId, '
        'nombreProductoSnapshot: $nombreProductoSnapshot, '
        'unidadesVendidas: $unidadesVendidas, '
        'ingresoCentavos: $ingresoCentavos'
        ')';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ProductSalesInsight &&
            runtimeType == other.runtimeType &&
            productoId == other.productoId &&
            nombreProductoSnapshot == other.nombreProductoSnapshot &&
            unidadesVendidas == other.unidadesVendidas &&
            ingresoCentavos == other.ingresoCentavos;
  }

  @override
  int get hashCode {
    return Object.hash(
      productoId,
      nombreProductoSnapshot,
      unidadesVendidas,
      ingresoCentavos,
    );
  }
}
