enum PaymentValidationType {
  success,
  warning,
  error,
}

class PaymentValidationMessage {
  final String titulo;
  final String descripcion;
  final PaymentValidationType tipo;

  const PaymentValidationMessage({
    required this.titulo,
    required this.descripcion,
    required this.tipo,
  });

  @override
  String toString() {
    return 'PaymentValidationMessage('
        'titulo: $titulo, '
        'descripcion: $descripcion, '
        'tipo: ${tipo.name}'
        ')';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PaymentValidationMessage &&
            runtimeType == other.runtimeType &&
            titulo == other.titulo &&
            descripcion == other.descripcion &&
            tipo == other.tipo;
  }

  @override
  int get hashCode {
    return Object.hash(
      titulo,
      descripcion,
      tipo,
    );
  }
}