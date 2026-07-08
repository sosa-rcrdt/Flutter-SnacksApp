enum SaleStatus {
  completada(nombreVisible: 'Completada'),
  cancelada(nombreVisible: 'Cancelada');

  final String nombreVisible;

  const SaleStatus({required this.nombreVisible});
}
