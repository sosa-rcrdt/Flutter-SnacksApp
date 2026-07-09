class DailySalesSummary {
  final DateTime fecha;
  final int totalVentas;
  final int ventasCompletadas;
  final int ventasCanceladas;
  final int totalVendidoCentavos;

  const DailySalesSummary({
    required this.fecha,
    required this.totalVentas,
    required this.ventasCompletadas,
    required this.ventasCanceladas,
    required this.totalVendidoCentavos,
  })  : assert(
          totalVentas >= 0,
          'El total de ventas no puede ser negativo.',
        ),
        assert(
          ventasCompletadas >= 0,
          'Las ventas completadas no pueden ser negativas.',
        ),
        assert(
          ventasCanceladas >= 0,
          'Las ventas canceladas no pueden ser negativas.',
        ),
        assert(
          totalVendidoCentavos >= 0,
          'El total vendido no puede ser negativo.',
        );

  bool get estaVacio => totalVentas == 0;

  int get ticketPromedioCentavos {
    if (ventasCompletadas == 0) {
      return 0;
    }

    return totalVendidoCentavos ~/ ventasCompletadas;
  }

  @override
  String toString() {
    return 'DailySalesSummary('
        'fecha: $fecha, '
        'totalVentas: $totalVentas, '
        'ventasCompletadas: $ventasCompletadas, '
        'ventasCanceladas: $ventasCanceladas, '
        'totalVendidoCentavos: $totalVendidoCentavos'
        ')';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is DailySalesSummary &&
            runtimeType == other.runtimeType &&
            fecha == other.fecha &&
            totalVentas == other.totalVentas &&
            ventasCompletadas == other.ventasCompletadas &&
            ventasCanceladas == other.ventasCanceladas &&
            totalVendidoCentavos == other.totalVendidoCentavos;
  }

  @override
  int get hashCode {
    return Object.hash(
      fecha,
      totalVentas,
      ventasCompletadas,
      ventasCanceladas,
      totalVendidoCentavos,
    );
  }
}