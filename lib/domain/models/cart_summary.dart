class CartSummary {
  final int cantidadTotalProductos;
  final int totalCentavos;

  const CartSummary({
    required this.cantidadTotalProductos,
    required this.totalCentavos,
  }) : assert(
         cantidadTotalProductos >= 0,
         'La cantidad total de productos no puede ser negativa.',
       ),
       assert(
         totalCentavos >= 0,
         'El total del carrito no puede ser negativo.',
       );

  static const empty = CartSummary(cantidadTotalProductos: 0, totalCentavos: 0);

  bool get estaVacio => cantidadTotalProductos == 0;

  CartSummary copyWith({int? cantidadTotalProductos, int? totalCentavos}) {
    return CartSummary(
      cantidadTotalProductos:
          cantidadTotalProductos ?? this.cantidadTotalProductos,
      totalCentavos: totalCentavos ?? this.totalCentavos,
    );
  }

  @override
  String toString() {
    return 'CartSummary('
        'cantidadTotalProductos: $cantidadTotalProductos, '
        'totalCentavos: $totalCentavos'
        ')';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CartSummary &&
            runtimeType == other.runtimeType &&
            cantidadTotalProductos == other.cantidadTotalProductos &&
            totalCentavos == other.totalCentavos;
  }

  @override
  int get hashCode {
    return Object.hash(cantidadTotalProductos, totalCentavos);
  }
}
