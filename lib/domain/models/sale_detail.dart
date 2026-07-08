class SaleDetail {
  final int id;
  final int ventaId;
  final int productoId;
  final String nombreProductoSnapshot;
  final int precioUnitarioCentavosSnapshot;
  final int cantidad;
  final int subtotalCentavos;

  const SaleDetail({
    required this.id,
    required this.ventaId,
    required this.productoId,
    required this.nombreProductoSnapshot,
    required this.precioUnitarioCentavosSnapshot,
    required this.cantidad,
    required this.subtotalCentavos,
  }) : assert(id > 0, 'El id del detalle debe ser mayor que 0.'),
       assert(ventaId > 0, 'El id de la venta debe ser mayor que 0.'),
       assert(productoId > 0, 'El id del producto debe ser mayor que 0.'),
       assert(
         precioUnitarioCentavosSnapshot >= 0,
         'El precio unitario no puede ser negativo.',
       ),
       assert(cantidad > 0, 'La cantidad debe ser mayor que 0.'),
       assert(subtotalCentavos >= 0, 'El subtotal no puede ser negativo.');

  SaleDetail copyWith({
    int? id,
    int? ventaId,
    int? productoId,
    String? nombreProductoSnapshot,
    int? precioUnitarioCentavosSnapshot,
    int? cantidad,
    int? subtotalCentavos,
  }) {
    return SaleDetail(
      id: id ?? this.id,
      ventaId: ventaId ?? this.ventaId,
      productoId: productoId ?? this.productoId,
      nombreProductoSnapshot:
          nombreProductoSnapshot ?? this.nombreProductoSnapshot,
      precioUnitarioCentavosSnapshot:
          precioUnitarioCentavosSnapshot ?? this.precioUnitarioCentavosSnapshot,
      cantidad: cantidad ?? this.cantidad,
      subtotalCentavos: subtotalCentavos ?? this.subtotalCentavos,
    );
  }

  @override
  String toString() {
    return 'SaleDetail('
        'id: $id, '
        'ventaId: $ventaId, '
        'productoId: $productoId, '
        'nombreProductoSnapshot: $nombreProductoSnapshot, '
        'precioUnitarioCentavosSnapshot: $precioUnitarioCentavosSnapshot, '
        'cantidad: $cantidad, '
        'subtotalCentavos: $subtotalCentavos'
        ')';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SaleDetail &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            ventaId == other.ventaId &&
            productoId == other.productoId &&
            nombreProductoSnapshot == other.nombreProductoSnapshot &&
            precioUnitarioCentavosSnapshot ==
                other.precioUnitarioCentavosSnapshot &&
            cantidad == other.cantidad &&
            subtotalCentavos == other.subtotalCentavos;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      ventaId,
      productoId,
      nombreProductoSnapshot,
      precioUnitarioCentavosSnapshot,
      cantidad,
      subtotalCentavos,
    );
  }
}
