enum SalesPeriodFilter {
  week(nombreVisible: 'Semana'),
  month(nombreVisible: 'Mes'),
  year(nombreVisible: 'Año');

  final String nombreVisible;

  const SalesPeriodFilter({required this.nombreVisible});
}
