class GlobalSalesSummary {
  final DateTime inicio;
  final DateTime finExclusivo;
  final int totalVentas;
  final int ventasCompletadas;
  final int ventasCanceladas;
  final int totalVendidoCentavos;

  const GlobalSalesSummary({
    required this.inicio,
    required this.finExclusivo,
    required this.totalVentas,
    required this.ventasCompletadas,
    required this.ventasCanceladas,
    required this.totalVendidoCentavos,
  }) : assert(totalVentas >= 0, 'El total de ventas no puede ser negativo.'),
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

  int get ticketPromedioCentavos {
    if (ventasCompletadas == 0) {
      return 0;
    }

    return totalVendidoCentavos ~/ ventasCompletadas;
  }

  bool get estaVacio => totalVentas == 0;
}
