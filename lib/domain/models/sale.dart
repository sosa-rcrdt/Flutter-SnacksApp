import 'sale_status.dart';

class Sale {
  final int id;
  final DateTime fechaHora;
  final int totalCentavos;
  final int dineroRecibidoCentavos;
  final int cambioCentavos;
  final SaleStatus estado;

  const Sale({
    required this.id,
    required this.fechaHora,
    required this.totalCentavos,
    required this.dineroRecibidoCentavos,
    required this.cambioCentavos,
    required this.estado,
  }) : assert(id > 0, 'El id de la venta debe ser mayor que 0.'),
       assert(
         totalCentavos >= 0,
         'El total de la venta no puede ser negativo.',
       ),
       assert(
         dineroRecibidoCentavos >= 0,
         'El dinero recibido no puede ser negativo.',
       ),
       assert(cambioCentavos >= 0, 'El cambio no puede ser negativo.');

  Sale copyWith({
    int? id,
    DateTime? fechaHora,
    int? totalCentavos,
    int? dineroRecibidoCentavos,
    int? cambioCentavos,
    SaleStatus? estado,
  }) {
    return Sale(
      id: id ?? this.id,
      fechaHora: fechaHora ?? this.fechaHora,
      totalCentavos: totalCentavos ?? this.totalCentavos,
      dineroRecibidoCentavos:
          dineroRecibidoCentavos ?? this.dineroRecibidoCentavos,
      cambioCentavos: cambioCentavos ?? this.cambioCentavos,
      estado: estado ?? this.estado,
    );
  }

  @override
  String toString() {
    return 'Sale('
        'id: $id, '
        'fechaHora: $fechaHora, '
        'totalCentavos: $totalCentavos, '
        'dineroRecibidoCentavos: $dineroRecibidoCentavos, '
        'cambioCentavos: $cambioCentavos, '
        'estado: ${estado.name}'
        ')';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Sale &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            fechaHora == other.fechaHora &&
            totalCentavos == other.totalCentavos &&
            dineroRecibidoCentavos == other.dineroRecibidoCentavos &&
            cambioCentavos == other.cambioCentavos &&
            estado == other.estado;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      fechaHora,
      totalCentavos,
      dineroRecibidoCentavos,
      cambioCentavos,
      estado,
    );
  }
}
