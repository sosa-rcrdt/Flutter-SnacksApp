class PaymentSummary {
  final int totalCentavos;
  final int? dineroRecibidoCentavos;

  const PaymentSummary({
    required this.totalCentavos,
    required this.dineroRecibidoCentavos,
  })  : assert(
          totalCentavos >= 0,
          'El total no puede ser negativo.',
        ),
        assert(
          dineroRecibidoCentavos == null || dineroRecibidoCentavos >= 0,
          'El dinero recibido no puede ser negativo.',
        );

  bool get dineroRecibidoValido => dineroRecibidoCentavos != null;

  bool get pagoSuficiente {
    return dineroRecibidoCentavos != null &&
        dineroRecibidoCentavos! >= totalCentavos &&
        totalCentavos > 0;
  }

  int get cambioCentavos {
    final recibido = dineroRecibidoCentavos ?? 0;
    final cambio = recibido - totalCentavos;

    return cambio > 0 ? cambio : 0;
  }

  int get faltanteCentavos {
    final recibido = dineroRecibidoCentavos ?? 0;
    final faltante = totalCentavos - recibido;

    return faltante > 0 ? faltante : 0;
  }

  bool get pagoExacto {
    return pagoSuficiente && cambioCentavos == 0;
  }

  PaymentSummary copyWith({
    int? totalCentavos,
    int? dineroRecibidoCentavos,
  }) {
    return PaymentSummary(
      totalCentavos: totalCentavos ?? this.totalCentavos,
      dineroRecibidoCentavos:
          dineroRecibidoCentavos ?? this.dineroRecibidoCentavos,
    );
  }

  @override
  String toString() {
    return 'PaymentSummary('
        'totalCentavos: $totalCentavos, '
        'dineroRecibidoCentavos: $dineroRecibidoCentavos'
        ')';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PaymentSummary &&
            runtimeType == other.runtimeType &&
            totalCentavos == other.totalCentavos &&
            dineroRecibidoCentavos == other.dineroRecibidoCentavos;
  }

  @override
  int get hashCode {
    return Object.hash(
      totalCentavos,
      dineroRecibidoCentavos,
    );
  }
}