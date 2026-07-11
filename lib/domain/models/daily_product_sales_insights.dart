import 'product_sales_insight.dart';

class DailyProductSalesInsights {
  final List<ProductSalesInsight> productos;

  const DailyProductSalesInsights({required this.productos});

  static const empty = DailyProductSalesInsights(productos: []);

  bool get estaVacio => productos.isEmpty;

  int get totalUnidadesVendidas {
    return productos.fold<int>(
      0,
      (total, producto) => total + producto.unidadesVendidas,
    );
  }

  int get totalIngresosCentavos {
    return productos.fold<int>(
      0,
      (total, producto) => total + producto.ingresoCentavos,
    );
  }

  ProductSalesInsight? get productoMasVendido {
    if (productos.isEmpty) {
      return null;
    }

    return productos.reduce((actual, siguiente) {
      if (siguiente.unidadesVendidas > actual.unidadesVendidas) {
        return siguiente;
      }

      if (siguiente.unidadesVendidas == actual.unidadesVendidas &&
          siguiente.ingresoCentavos > actual.ingresoCentavos) {
        return siguiente;
      }

      return actual;
    });
  }

  ProductSalesInsight? get productoMayorIngreso {
    if (productos.isEmpty) {
      return null;
    }

    return productos.reduce((actual, siguiente) {
      if (siguiente.ingresoCentavos > actual.ingresoCentavos) {
        return siguiente;
      }

      if (siguiente.ingresoCentavos == actual.ingresoCentavos &&
          siguiente.unidadesVendidas > actual.unidadesVendidas) {
        return siguiente;
      }

      return actual;
    });
  }

  @override
  String toString() {
    return 'DailyProductSalesInsights(productos: $productos)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is DailyProductSalesInsights &&
            runtimeType == other.runtimeType &&
            _listsAreEqual(productos, other.productos);
  }

  @override
  int get hashCode {
    return Object.hashAll(productos);
  }
}

bool _listsAreEqual<T>(List<T> first, List<T> second) {
  if (first.length != second.length) {
    return false;
  }

  for (var index = 0; index < first.length; index++) {
    if (first[index] != second[index]) {
      return false;
    }
  }

  return true;
}
