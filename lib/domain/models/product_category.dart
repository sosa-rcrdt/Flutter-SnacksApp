enum ProductCategory {
  elotesYEsquites(nombreVisible: 'Elotes y esquites', orden: 1),
  snacksPreparados(nombreVisible: 'Snacks preparados', orden: 2),
  bebidas(nombreVisible: 'Bebidas', orden: 3),
  postres(nombreVisible: 'Postres', orden: 4),
  especiales(nombreVisible: 'Especiales', orden: 5);

  final String nombreVisible;
  final int orden;

  const ProductCategory({required this.nombreVisible, required this.orden});
}
