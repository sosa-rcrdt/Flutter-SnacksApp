import 'product_category.dart';

class Product {
  final int id;
  final String nombre;
  final int precioCentavos;
  final ProductCategory categoria;
  final bool estaActivo;

  Product({
    required this.id,
    required this.nombre,
    required this.precioCentavos,
    required this.categoria,
    this.estaActivo = true,
  }) {
    if (id <= 0) {
      throw ArgumentError.value(
        id,
        'id',
        'El id del producto debe ser mayor que 0.',
      );
    }

    if (nombre.trim().isEmpty) {
      throw ArgumentError.value(
        nombre,
        'nombre',
        'El nombre del producto no puede estar vacío.',
      );
    }

    if (precioCentavos < 0) {
      throw ArgumentError.value(
        precioCentavos,
        'precioCentavos',
        'El precio del producto no puede ser negativo.',
      );
    }
  }

  Product copyWith({
    int? id,
    String? nombre,
    int? precioCentavos,
    ProductCategory? categoria,
    bool? estaActivo,
  }) {
    return Product(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      precioCentavos: precioCentavos ?? this.precioCentavos,
      categoria: categoria ?? this.categoria,
      estaActivo: estaActivo ?? this.estaActivo,
    );
  }

  @override
  String toString() {
    return 'Product('
        'id: $id, '
        'nombre: $nombre, '
        'precioCentavos: $precioCentavos, '
        'categoria: ${categoria.name}, '
        'estaActivo: $estaActivo'
        ')';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Product &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            nombre == other.nombre &&
            precioCentavos == other.precioCentavos &&
            categoria == other.categoria &&
            estaActivo == other.estaActivo;
  }

  @override
  int get hashCode {
    return Object.hash(id, nombre, precioCentavos, categoria, estaActivo);
  }
}
