import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/local/local_product_catalog.dart';
import '../../data/repositories/sale_repository.dart';
import '../../domain/models/product.dart';
import '../../domain/models/sale.dart';
import '../../domain/models/sale_detail.dart';
import '../../domain/models/sale_status.dart';

enum _StatisticsView { general, product }

class GlobalSalesStatisticsScreen extends StatefulWidget {
  const GlobalSalesStatisticsScreen({
    super.key,
    required this.saleRepository,
    required this.initialDate,
    this.onBack,
  });

  final SaleRepository saleRepository;
  final DateTime initialDate;
  final VoidCallback? onBack;

  @override
  State<GlobalSalesStatisticsScreen> createState() =>
      _GlobalSalesStatisticsScreenState();
}

class _GlobalSalesStatisticsScreenState
    extends State<GlobalSalesStatisticsScreen> {
  late DateTime _anchorDate;
  late Future<_WeeklySalesReport> _reportFuture;

  _StatisticsView _selectedView = _StatisticsView.general;
  int? _selectedProductId;

  @override
  void initState() {
    super.initState();

    _anchorDate = _normalizeDate(widget.initialDate);
    _reportFuture = _loadReport();
  }

  DateTime _today() {
    return _normalizeDate(DateTime.now());
  }

  _WeekPeriod _currentWeek() {
    return _WeekPeriod.fromDate(_anchorDate);
  }

  Future<_WeeklySalesReport> _loadReport() async {
    final week = _currentWeek();

    final sales = await widget.saleRepository.obtenerVentasEntre(
      inicio: week.start,
      fin: week.endExclusive,
    );

    final completedSales = sales
        .where((sale) => sale.estado == SaleStatus.completada)
        .toList();

    final details = await widget.saleRepository.obtenerDetallesDeVentas(
      completedSales.map((sale) => sale.id).toList(),
    );

    final products = LocalProductCatalog.obtenerProductosActivos();

    final productStats = _buildProductStats(
      products: products,
      details: details,
    );

    return _WeeklySalesReport(
      week: week,
      sales: sales,
      completedSales: completedSales,
      details: details,
      products: products,
      productStats: productStats,
    );
  }

  void _reload() {
    setState(() {
      _reportFuture = _loadReport();
    });
  }

  void _changeAnchorDate(DateTime date) {
    setState(() {
      _anchorDate = _normalizeDate(date);
      _selectedProductId = null;
      _reportFuture = _loadReport();
    });
  }

  Future<void> _openDatePicker() async {
    final selectedDate = await showDialog<DateTime>(
      context: context,
      builder: (context) {
        return _WeekPickerDialog(
          initialDate: _anchorDate,
          firstDate: DateTime(2020),
          lastDate: _today(),
        );
      },
    );

    if (selectedDate == null) {
      return;
    }

    _changeAnchorDate(selectedDate);
  }

  void _goToPreviousWeek() {
    _changeAnchorDate(_currentWeek().start.subtract(const Duration(days: 7)));
  }

  void _goToCurrentWeek() {
    _changeAnchorDate(_today());
  }

  void _goToNextWeek() {
    if (!_canGoToNextWeek) {
      return;
    }

    _changeAnchorDate(_currentWeek().start.add(const Duration(days: 7)));
  }

  bool get _canGoToNextWeek {
    final selectedWeek = _currentWeek();
    final currentWeek = _WeekPeriod.fromDate(_today());

    return selectedWeek.start.isBefore(currentWeek.start);
  }

  void _back() {
    if (widget.onBack != null) {
      widget.onBack!();
      return;
    }

    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final currentWeek = _currentWeek();

    return Scaffold(
      backgroundColor: AppColors.fondoAplicacion,
      body: SafeArea(
        child: FutureBuilder<_WeeklySalesReport>(
          future: _reportFuture,
          builder: (context, snapshot) {
            final isLoading =
                snapshot.connectionState == ConnectionState.waiting ||
                snapshot.connectionState == ConnectionState.active;

            final report = snapshot.data;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 860),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _StatisticsTopBar(onBack: _back),
                      const SizedBox(height: 16),
                      _WeekNavigationCard(
                        week: currentWeek,
                        canGoToNextWeek: _canGoToNextWeek,
                        onPreviousWeek: _goToPreviousWeek,
                        onCurrentWeek: _goToCurrentWeek,
                        onNextWeek: _goToNextWeek,
                        onOpenDatePicker: _openDatePicker,
                      ),
                      const SizedBox(height: 16),
                      _DashboardTabs(
                        selectedView: _selectedView,
                        onChanged: (view) {
                          setState(() {
                            _selectedView = view;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      if (isLoading)
                        const _StatisticsLoadingCard()
                      else if (snapshot.hasError || report == null)
                        _StatisticsErrorCard(onRetry: _reload)
                      else
                        switch (_selectedView) {
                          _StatisticsView.general => _GeneralDashboard(
                            report: report,
                          ),
                          _StatisticsView.product => _ProductDashboard(
                            report: report,
                            selectedProductId: _selectedProductId,
                            onProductChanged: (productId) {
                              setState(() {
                                _selectedProductId = productId;
                              });
                            },
                          ),
                        },
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StatisticsTopBar extends StatelessWidget {
  const _StatisticsTopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FilledButton.icon(
        onPressed: onBack,
        icon: const Icon(Icons.arrow_back_rounded, size: 20),
        label: const Text('Ventas del día'),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.verdeOscuro,
          foregroundColor: AppColors.amarilloMaiz,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _WeekNavigationCard extends StatelessWidget {
  const _WeekNavigationCard({
    required this.week,
    required this.canGoToNextWeek,
    required this.onPreviousWeek,
    required this.onCurrentWeek,
    required this.onNextWeek,
    required this.onOpenDatePicker,
  });

  final _WeekPeriod week;
  final bool canGoToNextWeek;
  final VoidCallback onPreviousWeek;
  final VoidCallback onCurrentWeek;
  final VoidCallback onNextWeek;
  final VoidCallback onOpenDatePicker;

  @override
  Widget build(BuildContext context) {
    final currentWeek = _WeekPeriod.fromDate(DateTime.now());
    final isCurrentWeek = _isSameDate(week.start, currentWeek.start);

    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OutlinedButton.icon(
              onPressed: onOpenDatePicker,
              icon: const Icon(Icons.calendar_month_rounded),
              label: Text(week.visibleName, overflow: TextOverflow.ellipsis),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.verdeOscuro,
                minimumSize: const Size.fromHeight(48),
                side: const BorderSide(color: AppColors.verdePrincipal),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: isCurrentWeek
                      ? AppColors.fondoExito
                      : AppColors.fondoAdvertencia,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  isCurrentWeek ? 'SEMANA ACTUAL' : 'SEMANA SELECCIONADA',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isCurrentWeek
                        ? AppColors.exito
                        : AppColors.advertencia,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 44,
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: onPreviousWeek,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.amarilloMaiz,
                        foregroundColor: AppColors.verdeOscuro,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      child: const FittedBox(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.chevron_left_rounded, size: 20),
                            SizedBox(width: 2),
                            Text('Anterior'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isCurrentWeek ? null : onCurrentWeek,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.verdeOscuro,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        side: const BorderSide(color: AppColors.verdePrincipal),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      child: const FittedBox(child: Text('Actual')),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      onPressed: canGoToNextWeek ? onNextWeek : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.amarilloMaiz,
                        foregroundColor: AppColors.verdeOscuro,
                        disabledBackgroundColor: AppColors.botonDeshabilitado,
                        disabledForegroundColor: AppColors.textoDeshabilitado,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      child: const FittedBox(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Siguiente'),
                            SizedBox(width: 2),
                            Icon(Icons.chevron_right_rounded, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardTabs extends StatelessWidget {
  const _DashboardTabs({required this.selectedView, required this.onChanged});

  final _StatisticsView selectedView;
  final ValueChanged<_StatisticsView> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Row(
          children: [
            Expanded(
              child: _DashboardTabButton(
                label: 'Global',
                icon: Icons.donut_large_rounded,
                selected: selectedView == _StatisticsView.general,
                onTap: () => onChanged(_StatisticsView.general),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _DashboardTabButton(
                label: 'Producto',
                icon: Icons.inventory_2_rounded,
                selected: selectedView == _StatisticsView.product,
                onTap: () => onChanged(_StatisticsView.product),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardTabButton extends StatelessWidget {
  const _DashboardTabButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = selected ? AppColors.verdeOscuro : Colors.white;
    final foregroundColor = selected
        ? AppColors.amarilloMaiz
        : AppColors.verdeOscuro;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: foregroundColor, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: foregroundColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatisticsLoadingCard extends StatelessWidget {
  const _StatisticsLoadingCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: const Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 14),
            Text('Cargando estadísticas...'),
          ],
        ),
      ),
    );
  }
}

class _StatisticsErrorCard extends StatelessWidget {
  const _StatisticsErrorCard({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.fondoError,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Text(
              'No se pudieron cargar las estadísticas.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              child: const Text('Intentar nuevamente'),
            ),
          ],
        ),
      ),
    );
  }
}

class _GeneralDashboard extends StatelessWidget {
  const _GeneralDashboard({required this.report});

  final _WeeklySalesReport report;

  @override
  Widget build(BuildContext context) {
    final totalUnits = report.totalUnitsSold;

    final productsWithSales = report.productStats
        .where((product) => product.unitsSold > 0)
        .length;

    final productsWithoutSales = report.productStats.length - productsWithSales;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DashboardSummaryCard(
          title: 'Resumen semanal',
          description:
              'Lectura general de movimiento por productos durante la semana seleccionada.',
          metrics: [
            _DashboardMetric(
              title: 'Ventas completadas',
              value: '${report.completedSales.length}',
              helper: 'ventas',
              icon: Icons.receipt_long_rounded,
              highlighted: true,
            ),
            _DashboardMetric(
              title: 'Unidades vendidas',
              value: '$totalUnits',
              helper: 'productos',
              icon: Icons.shopping_bag_rounded,
            ),
            _DashboardMetric(
              title: 'Con venta',
              value: '$productsWithSales',
              helper: 'de ${report.productStats.length}',
              icon: Icons.trending_up_rounded,
            ),
          ],
        ),
        const SizedBox(height: 16),
        _ProductShareChart(
          products: report.productStats,
          totalUnits: totalUnits,
        ),
      ],
    );
  }
}

class _ProductDashboard extends StatelessWidget {
  const _ProductDashboard({
    required this.report,
    required this.selectedProductId,
    required this.onProductChanged,
  });

  final _WeeklySalesReport report;
  final int? selectedProductId;
  final ValueChanged<int?> onProductChanged;

  @override
  Widget build(BuildContext context) {
    if (report.productStats.isEmpty) {
      return const _EmptyStatisticsCard(
        message: 'No hay productos registrados para analizar.',
      );
    }

    final selectedProduct = _resolveSelectedProduct(
      products: report.productStats,
      selectedProductId: selectedProductId,
    );

    final points = _buildWeeklyProductPoints(
      week: report.week,
      salesById: report.completedSalesById,
      details: report.details,
      productId: selectedProduct.product.id,
    );

    final activeDays = points.where((point) => point.unitsSold > 0).length;

    final strongestDay = points.reduce((actual, next) {
      if (next.unitsSold > actual.unitsSold) {
        return next;
      }

      return actual;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ProductPickerCard(
          selectedProduct: selectedProduct,
          products: report.productStats,
          onProductChanged: onProductChanged,
        ),
        const SizedBox(height: 16),
        _DashboardSummaryCard(
          title: selectedProduct.product.nombre,
          description:
              'Lectura individual del producto dentro de la semana seleccionada.',
          metrics: [
            _DashboardMetric(
              title: 'Unidades vendidas',
              value: '${selectedProduct.unitsSold}',
              helper: 'productos',
              icon: Icons.shopping_bag_rounded,
              highlighted: true,
            ),
            _DashboardMetric(
              title: 'Participación',
              value:
                  '${_formatPercentage(selectedProduct.percentageOf(report.totalUnitsSold))}%',
              helper: 'del total',
              icon: Icons.pie_chart_rounded,
            ),
            _DashboardMetric(
              title: 'Días con venta',
              value: '$activeDays',
              helper: 'de 7 días',
              icon: Icons.calendar_today_rounded,
            ),
            _DashboardMetric(
              title: 'Día más fuerte',
              value: strongestDay.unitsSold == 0
                  ? '0'
                  : '${strongestDay.unitsSold}',
              helper: strongestDay.unitsSold == 0
                  ? 'sin ventas'
                  : strongestDay.label,
              icon: Icons.bolt_rounded,
            ),
          ],
        ),
        const SizedBox(height: 16),
        _WeeklyHistogramChart(
          productName: selectedProduct.product.nombre,
          points: points,
        ),
      ],
    );
  }
}

class _ProductPickerCard extends StatelessWidget {
  const _ProductPickerCard({
    required this.selectedProduct,
    required this.products,
    required this.onProductChanged,
  });

  final _ProductStat selectedProduct;
  final List<_ProductStat> products;
  final ValueChanged<int?> onProductChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DropdownButtonFormField<int>(
          value: selectedProduct.product.id,
          items: products.map((product) {
            return DropdownMenuItem<int>(
              value: product.product.id,
              child: Text(product.product.nombre),
            );
          }).toList(),
          onChanged: onProductChanged,
          decoration: InputDecoration(
            labelText: 'Producto a analizar',
            prefixIcon: const Icon(Icons.inventory_2_rounded),
            filled: true,
            fillColor: AppColors.fondoAplicacion,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: AppColors.verdePrincipal.withValues(alpha: 0.34),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: AppColors.verdePrincipal,
                width: 1.4,
              ),
            ),
          ),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.verdeOscuro,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _DashboardSummaryCard extends StatelessWidget {
  const _DashboardSummaryCard({
    required this.title,
    required this.description,
    required this.metrics,
  });

  final String title;
  final String description;
  final List<_DashboardMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.tarjetaMenu,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = constraints.maxWidth >= 620
                ? (constraints.maxWidth - 12) / 2
                : constraints.maxWidth;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.verdeOscuro,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.verdePrincipal,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    for (final metric in metrics)
                      SizedBox(
                        width: cardWidth,
                        child: _MetricTile(metric: metric),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DashboardMetric {
  final String title;
  final String value;
  final String helper;
  final IconData icon;
  final bool highlighted;

  const _DashboardMetric({
    required this.title,
    required this.value,
    required this.helper,
    required this.icon,
    this.highlighted = false,
  });
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.metric});

  final _DashboardMetric metric;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: metric.highlighted ? AppColors.fondoExito : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: metric.highlighted
              ? AppColors.exito.withValues(alpha: 0.18)
              : AppColors.verdePrincipal.withValues(alpha: 0.12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: metric.highlighted
                    ? AppColors.exito
                    : AppColors.verdeOscuro,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                metric.icon,
                color: metric.highlighted
                    ? Colors.white
                    : AppColors.amarilloMaiz,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    metric.title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.verdePrincipal,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: metric.value,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: AppColors.verdeOscuro,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        TextSpan(
                          text: ' ${metric.helper}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.verdePrincipal,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductShareChart extends StatelessWidget {
  const _ProductShareChart({required this.products, required this.totalUnits});

  final List<_ProductStat> products;
  final int totalUnits;

  static const double _chartHeight = 230;
  static const double _barSlotWidth = 86;
  static const double _barMaxHeight = 190;

  @override
  Widget build(BuildContext context) {
    final sortedProducts = List<_ProductStat>.from(products)
      ..sort((a, b) {
        final unitsComparison = b.unitsSold.compareTo(a.unitsSold);

        if (unitsComparison != 0) {
          return unitsComparison;
        }

        return a.product.nombre.compareTo(b.product.nombre);
      });

    final chartWidth = sortedProducts.length * _barSlotWidth;

    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ChartHeader(
              title: 'Participación por producto',
              description:
                  'Distribución del 100% de unidades vendidas en la semana. Desliza horizontalmente para ver todos los productos.',
              icon: Icons.stacked_bar_chart_rounded,
            ),
            const SizedBox(height: 18),
            if (totalUnits == 0)
              const _EmptyStatisticsCard(
                message: 'No hay productos vendidos en esta semana.',
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _PercentageAxis(height: _chartHeight),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          SizedBox(
                            width: chartWidth,
                            height: _chartHeight,
                            child: Stack(
                              children: [
                                const _ChartGridLines(),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    for (final product in sortedProducts)
                                      SizedBox(
                                        width: _barSlotWidth,
                                        child: _ShareChartBar(
                                          product: product,
                                          totalUnits: totalUnits,
                                          maxHeight: _barMaxHeight,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: chartWidth,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (final product in sortedProducts)
                                  SizedBox(
                                    width: _barSlotWidth,
                                    child: _RotatedProductLabel(
                                      text: product.product.nombre,
                                      isMuted: product.unitsSold == 0,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _ShareChartBar extends StatelessWidget {
  const _ShareChartBar({
    required this.product,
    required this.totalUnits,
    required this.maxHeight,
  });

  final _ProductStat product;
  final int totalUnits;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final percentage = product.percentageOf(totalUnits);
    final filledHeight = (maxHeight * (percentage / 100)).clamp(0.0, maxHeight);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '${_formatPercentage(percentage)}%',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.verdeOscuro,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${product.unitsSold}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.verdePrincipal,
            fontWeight: FontWeight.w800,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 46,
          height: maxHeight,
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            color: AppColors.fondoExito,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.verdePrincipal.withValues(alpha: 0.10),
            ),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            width: 46,
            height: filledHeight,
            decoration: BoxDecoration(
              color: product.unitsSold == 0
                  ? AppColors.botonDeshabilitado
                  : AppColors.verdePrincipal,
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ],
    );
  }
}

class _WeeklyHistogramChart extends StatelessWidget {
  const _WeeklyHistogramChart({
    required this.productName,
    required this.points,
  });

  final String productName;
  final List<_ProductDayPoint> points;

  static const double _chartHeight = 250;
  static const double _barMaxHeight = 205;

  @override
  Widget build(BuildContext context) {
    final maxUnits = points.fold<int>(
      0,
      (maxUnits, point) =>
          point.unitsSold > maxUnits ? point.unitsSold : maxUnits,
    );

    final axisMax = maxUnits <= 0 ? 4 : maxUnits;

    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ChartHeader(
              title: 'Histograma semanal',
              description:
                  'Unidades vendidas de $productName por día. La altura de cada barra permite detectar días fuertes, débiles o sin movimiento.',
              icon: Icons.bar_chart_rounded,
            ),
            const SizedBox(height: 18),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _UnitsAxis(height: _chartHeight, maxUnits: axisMax),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: _chartHeight + 46,
                    child: Column(
                      children: [
                        SizedBox(
                          height: _chartHeight,
                          child: Stack(
                            children: [
                              const _ChartGridLines(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  for (final point in points) ...[
                                    Expanded(
                                      child: _HistogramChartBar(
                                        point: point,
                                        maxUnits: axisMax,
                                        maxHeight: _barMaxHeight,
                                      ),
                                    ),
                                    if (point != points.last)
                                      const SizedBox(width: 8),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            for (final point in points) ...[
                              Expanded(child: _HistogramDayLabel(point: point)),
                              if (point != points.last)
                                const SizedBox(width: 8),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HistogramChartBar extends StatelessWidget {
  const _HistogramChartBar({
    required this.point,
    required this.maxUnits,
    required this.maxHeight,
  });

  final _ProductDayPoint point;
  final int maxUnits;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final filledHeight = maxUnits == 0
        ? 0.0
        : (maxHeight * (point.unitsSold / maxUnits)).clamp(0.0, maxHeight);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          point.unitsSold.toString(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.verdeOscuro,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 52),
          height: maxHeight,
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            color: AppColors.fondoExito,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.verdePrincipal.withValues(alpha: 0.10),
            ),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            height: filledHeight,
            decoration: BoxDecoration(
              color: point.unitsSold == 0
                  ? AppColors.botonDeshabilitado
                  : AppColors.verdePrincipal,
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ],
    );
  }
}

class _HistogramDayLabel extends StatelessWidget {
  const _HistogramDayLabel({required this.point});

  final _ProductDayPoint point;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          point.label.toUpperCase(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.verdePrincipal,
            fontWeight: FontWeight.w900,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          point.day.day.toString(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.verdeOscuro,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _ChartHeader extends StatelessWidget {
  const _ChartHeader({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.fondoExito,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: AppColors.verdePrincipal, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.verdeOscuro,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.verdePrincipal,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PercentageAxis extends StatelessWidget {
  const _PercentageAxis({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final value in const ['100%', '75%', '50%', '25%', '0%'])
            Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.verdePrincipal,
                fontWeight: FontWeight.w700,
                fontSize: 10,
              ),
            ),
        ],
      ),
    );
  }
}

class _UnitsAxis extends StatelessWidget {
  const _UnitsAxis({required this.height, required this.maxUnits});

  final double height;
  final int maxUnits;

  @override
  Widget build(BuildContext context) {
    final values = [
      maxUnits,
      (maxUnits * 0.75).round(),
      (maxUnits * 0.50).round(),
      (maxUnits * 0.25).round(),
      0,
    ];

    return SizedBox(
      width: 32,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final value in values)
            Text(
              value.toString(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.verdePrincipal,
                fontWeight: FontWeight.w700,
                fontSize: 10,
              ),
            ),
        ],
      ),
    );
  }
}

class _ChartGridLines extends StatelessWidget {
  const _ChartGridLines();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var index = 0; index < 5; index++)
          Container(
            height: 1,
            color: AppColors.verdePrincipal.withValues(alpha: 0.12),
          ),
      ],
    );
  }
}

class _RotatedProductLabel extends StatelessWidget {
  const _RotatedProductLabel({required this.text, required this.isMuted});

  final String text;
  final bool isMuted;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: isMuted ? AppColors.textoDeshabilitado : AppColors.verdeOscuro,
          fontWeight: FontWeight.w900,
          fontSize: 10,
          height: 1.1,
        ),
      ),
    );
  }
}

class _EmptyStatisticsCard extends StatelessWidget {
  const _EmptyStatisticsCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.fondoAdvertencia,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.advertencia,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _WeekPickerDialog extends StatefulWidget {
  const _WeekPickerDialog({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  State<_WeekPickerDialog> createState() => _WeekPickerDialogState();
}

class _WeekPickerDialogState extends State<_WeekPickerDialog> {
  late DateTime _selectedDate;
  late DateTime _visibleMonth;

  @override
  void initState() {
    super.initState();

    _selectedDate = _normalizeDate(widget.initialDate);
    _visibleMonth = DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
      1,
    );
  }

  bool get _canGoToPreviousMonth {
    final firstAllowedMonth = DateTime(
      widget.firstDate.year,
      widget.firstDate.month,
      1,
    );

    return _visibleMonth.isAfter(firstAllowedMonth);
  }

  bool get _canGoToNextMonth {
    final lastAllowedMonth = DateTime(
      widget.lastDate.year,
      widget.lastDate.month,
      1,
    );

    return _visibleMonth.isBefore(lastAllowedMonth);
  }

  void _goToPreviousMonth() {
    if (!_canGoToPreviousMonth) {
      return;
    }

    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1, 1);
    });
  }

  void _goToNextMonth() {
    if (!_canGoToNextMonth) {
      return;
    }

    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1, 1);
    });
  }

  void _selectDay(DateTime day) {
    if (_isDisabled(day)) {
      return;
    }

    setState(() {
      _selectedDate = day;
    });
  }

  bool _isDisabled(DateTime day) {
    final normalizedDay = _normalizeDate(day);

    return normalizedDay.isBefore(_normalizeDate(widget.firstDate)) ||
        normalizedDay.isAfter(_normalizeDate(widget.lastDate));
  }

  @override
  Widget build(BuildContext context) {
    final selectedWeek = _WeekPeriod.fromDate(_selectedDate);
    final days = _calendarCellsForMonth(_visibleMonth);

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: _canGoToPreviousMonth
                          ? _goToPreviousMonth
                          : null,
                      icon: const Icon(Icons.chevron_left_rounded),
                      color: AppColors.verdeOscuro,
                    ),
                    Expanded(
                      child: Text(
                        '${_monthName(_visibleMonth.month)} de ${_visibleMonth.year}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AppColors.verdeOscuro,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ),
                    IconButton(
                      onPressed: _canGoToNextMonth ? _goToNextMonth : null,
                      icon: const Icon(Icons.chevron_right_rounded),
                      color: AppColors.verdeOscuro,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  selectedWeek.visibleName,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.verdePrincipal,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    for (final weekday in const [
                      'L',
                      'M',
                      'M',
                      'J',
                      'V',
                      'S',
                      'D',
                    ])
                      Expanded(
                        child: Text(
                          weekday,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.verdePrincipal,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: days.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                  ),
                  itemBuilder: (context, index) {
                    final day = days[index];

                    if (day == null) {
                      return const SizedBox.shrink();
                    }

                    final disabled = _isDisabled(day);
                    final isSelected = _isSameDate(day, _selectedDate);
                    final isToday = _isSameDate(day, DateTime.now());
                    final isInsideSelectedWeek = _isDateInsideWeek(
                      day: day,
                      week: selectedWeek,
                    );

                    return _CalendarDayButton(
                      day: day,
                      disabled: disabled,
                      isSelected: isSelected,
                      isToday: isToday,
                      isInsideSelectedWeek: isInsideSelectedWeek,
                      onTap: () => _selectDay(day),
                    );
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.verdeOscuro,
                          side: const BorderSide(
                            color: AppColors.verdePrincipal,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.of(context).pop(_selectedDate);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.verdeOscuro,
                          foregroundColor: AppColors.amarilloMaiz,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: const Text('Aceptar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CalendarDayButton extends StatelessWidget {
  const _CalendarDayButton({
    required this.day,
    required this.disabled,
    required this.isSelected,
    required this.isToday,
    required this.isInsideSelectedWeek,
    required this.onTap,
  });

  final DateTime day;
  final bool disabled;
  final bool isSelected;
  final bool isToday;
  final bool isInsideSelectedWeek;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected
        ? AppColors.verdeOscuro
        : isInsideSelectedWeek
        ? AppColors.fondoExito
        : Colors.white;

    final foregroundColor = isSelected
        ? AppColors.amarilloMaiz
        : disabled
        ? AppColors.textoDeshabilitado
        : AppColors.verdeOscuro;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isToday
                  ? AppColors.amarilloMaiz
                  : isInsideSelectedWeek
                  ? AppColors.verdePrincipal.withValues(alpha: 0.45)
                  : Colors.transparent,
              width: isToday ? 2 : 1,
            ),
          ),
          child: Text(
            day.day.toString(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _WeeklySalesReport {
  final _WeekPeriod week;
  final List<Sale> sales;
  final List<Sale> completedSales;
  final List<SaleDetail> details;
  final List<Product> products;
  final List<_ProductStat> productStats;

  const _WeeklySalesReport({
    required this.week,
    required this.sales,
    required this.completedSales,
    required this.details,
    required this.products,
    required this.productStats,
  });

  int get totalUnitsSold {
    return productStats.fold<int>(
      0,
      (total, product) => total + product.unitsSold,
    );
  }

  Map<int, Sale> get completedSalesById {
    return {for (final sale in completedSales) sale.id: sale};
  }
}

class _WeekPeriod {
  final DateTime start;
  final DateTime endExclusive;

  const _WeekPeriod({required this.start, required this.endExclusive});

  factory _WeekPeriod.fromDate(DateTime date) {
    final normalizedDate = _normalizeDate(date);

    final start = normalizedDate.subtract(
      Duration(days: normalizedDate.weekday - 1),
    );

    return _WeekPeriod(
      start: start,
      endExclusive: start.add(const Duration(days: 7)),
    );
  }

  String get visibleName {
    final endInclusive = endExclusive.subtract(const Duration(days: 1));

    if (start.month == endInclusive.month && start.year == endInclusive.year) {
      return 'Semana del ${start.day} al ${endInclusive.day} de ${_monthName(start.month)} de ${start.year}';
    }

    return 'Semana del ${start.day} de ${_monthName(start.month)} al ${endInclusive.day} de ${_monthName(endInclusive.month)} de ${endInclusive.year}';
  }
}

class _ProductStat {
  final Product product;
  final int unitsSold;

  const _ProductStat({required this.product, required this.unitsSold});

  double percentageOf(int totalUnits) {
    if (totalUnits == 0) {
      return 0;
    }

    return (unitsSold / totalUnits) * 100;
  }
}

class _ProductDayPoint {
  final DateTime day;
  final String label;
  final int unitsSold;

  const _ProductDayPoint({
    required this.day,
    required this.label,
    required this.unitsSold,
  });
}

List<_ProductStat> _buildProductStats({
  required List<Product> products,
  required List<SaleDetail> details,
}) {
  final unitsByProductId = <int, int>{};

  for (final detail in details) {
    unitsByProductId[detail.productoId] =
        (unitsByProductId[detail.productoId] ?? 0) + detail.cantidad;
  }

  return products.map((product) {
    return _ProductStat(
      product: product,
      unitsSold: unitsByProductId[product.id] ?? 0,
    );
  }).toList();
}

_ProductStat _resolveSelectedProduct({
  required List<_ProductStat> products,
  required int? selectedProductId,
}) {
  if (selectedProductId != null) {
    return products.firstWhere(
      (product) => product.product.id == selectedProductId,
      orElse: () => products.first,
    );
  }

  return products.firstWhere(
    (product) => product.unitsSold > 0,
    orElse: () => products.first,
  );
}

List<_ProductDayPoint> _buildWeeklyProductPoints({
  required _WeekPeriod week,
  required Map<int, Sale> salesById,
  required List<SaleDetail> details,
  required int productId,
}) {
  final totals = List<int>.filled(7, 0);

  for (final detail in details) {
    if (detail.productoId != productId) {
      continue;
    }

    final sale = salesById[detail.ventaId];

    if (sale == null) {
      continue;
    }

    final dayIndex = sale.fechaHora.difference(week.start).inDays;

    if (dayIndex < 0 || dayIndex >= 7) {
      continue;
    }

    totals[dayIndex] += detail.cantidad;
  }

  return [
    for (var index = 0; index < 7; index++)
      _ProductDayPoint(
        day: week.start.add(Duration(days: index)),
        label: _shortWeekdayName(index + 1),
        unitsSold: totals[index],
      ),
  ];
}

List<DateTime?> _calendarCellsForMonth(DateTime month) {
  final firstDayOfMonth = DateTime(month.year, month.month, 1);

  final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);

  final leadingEmptyCells = firstDayOfMonth.weekday - 1;
  final cells = <DateTime?>[
    for (var index = 0; index < leadingEmptyCells; index++) null,
    for (var day = 1; day <= lastDayOfMonth.day; day++)
      DateTime(month.year, month.month, day),
  ];

  while (cells.length % 7 != 0) {
    cells.add(null);
  }

  return cells;
}

bool _isDateInsideWeek({required DateTime day, required _WeekPeriod week}) {
  final normalizedDay = _normalizeDate(day);

  return !normalizedDay.isBefore(week.start) &&
      normalizedDay.isBefore(week.endExclusive);
}

DateTime _normalizeDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

bool _isSameDate(DateTime first, DateTime second) {
  return first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}

String _formatPercentage(double value) {
  if (value == 0) {
    return '0';
  }

  if (value >= 10) {
    return value.toStringAsFixed(0);
  }

  return value.toStringAsFixed(1);
}

String _monthName(int month) {
  const months = [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre',
  ];

  return months[month - 1];
}

String _shortWeekdayName(int weekday) {
  const weekdays = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

  return weekdays[weekday - 1];
}
