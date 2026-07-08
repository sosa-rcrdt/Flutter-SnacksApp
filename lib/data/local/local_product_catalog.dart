import '../../domain/models/product.dart';
import '../../domain/models/product_category.dart';

abstract final class LocalProductCatalog {
  static List<Product> obtenerProductosActivos() {
    final productosActivos = _productos.where((producto) => producto.estaActivo).toList();

    productosActivos.sort((a, b) {
      final comparacionCategoria = a.categoria.orden.compareTo(b.categoria.orden);

      if (comparacionCategoria != 0) {
        return comparacionCategoria;
      }

      return a.id.compareTo(b.id);
    });

    return List.unmodifiable(productosActivos);
  }

  static final List<Product> _productos = [
    Product(
      id: 1,
      nombre: 'Elote',
      precioCentavos: 3000,
      categoria: ProductCategory.elotesYEsquites,
    ),
    Product(
      id: 2,
      nombre: 'Esquite chico',
      precioCentavos: 3000,
      categoria: ProductCategory.elotesYEsquites,
    ),
    Product(
      id: 3,
      nombre: 'Esquite mediano',
      precioCentavos: 3500,
      categoria: ProductCategory.elotesYEsquites,
    ),
    Product(
      id: 4,
      nombre: 'Esquite grande',
      precioCentavos: 4500,
      categoria: ProductCategory.elotesYEsquites,
    ),
    Product(
      id: 5,
      nombre: 'Doriesquite',
      precioCentavos: 6000,
      categoria: ProductCategory.snacksPreparados,
    ),
    Product(
      id: 6,
      nombre: 'Sopa con esquite',
      precioCentavos: 6000,
      categoria: ProductCategory.snacksPreparados,
    ),
    Product(
      id: 7,
      nombre: 'Nachos con esquite',
      precioCentavos: 6000,
      categoria: ProductCategory.snacksPreparados,
    ),
    Product(
      id: 8,
      nombre: 'Elote revolcado',
      precioCentavos: 5000,
      categoria: ProductCategory.elotesYEsquites,
    ),
    Product(
      id: 9,
      nombre: 'Cheetoelote',
      precioCentavos: 5000,
      categoria: ProductCategory.elotesYEsquites,
    ),
    Product(
      id: 10,
      nombre: 'Frappes',
      precioCentavos: 5000,
      categoria: ProductCategory.bebidas,
    ),
    Product(
      id: 11,
      nombre: 'Gomi Boing',
      precioCentavos: 5000,
      categoria: ProductCategory.bebidas,
    ),
    Product(
      id: 12,
      nombre: 'Arizona preparado',
      precioCentavos: 4000,
      categoria: ProductCategory.bebidas,
    ),
    Product(
      id: 13,
      nombre: 'Waffles',
      precioCentavos: 4000,
      categoria: ProductCategory.postres,
    ),
    Product(
      id: 14,
      nombre: 'Mini hot cakes',
      precioCentavos: 4000,
      categoria: ProductCategory.postres,
    ),
    Product(
      id: 15,
      nombre: 'Dorilocos',
      precioCentavos: 6000,
      categoria: ProductCategory.snacksPreparados,
    ),
    Product(
      id: 16,
      nombre: 'Nachos con queso y jalapeños',
      precioCentavos: 6000,
      categoria: ProductCategory.snacksPreparados,
    ),
    Product(
      id: 17,
      nombre: 'Nachote',
      precioCentavos: 5000,
      categoria: ProductCategory.snacksPreparados,
    ),
    Product(
      id: 18,
      nombre: 'Cheevaso',
      precioCentavos: 5000,
      categoria: ProductCategory.especiales,
    ),
    Product(
      id: 19,
      nombre: 'Greñuda',
      precioCentavos: 10000,
      categoria: ProductCategory.especiales,
    ),
    Product(
      id: 20,
      nombre: 'Charolita mix',
      precioCentavos: 14000,
      categoria: ProductCategory.especiales,
    ),
  ];
}