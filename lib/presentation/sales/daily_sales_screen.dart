import 'package:flutter/material.dart';

import '../../core/format/money_format.dart';
import '../../core/theme/app_colors.dart';
import '../../data/repositories/sale_repository.dart';
import '../../domain/models/daily_sales_summary.dart';
import '../../domain/models/sale.dart';
import '../../domain/models/sale_status.dart';
import '../../domain/use_cases/calculate_daily_sales_summary.dart';

class DailySalesScreen extends StatefulWidget {
  const DailySalesScreen({
    super.key,
    required this.saleRepository,
    this.onBackToMenu,
  });

  final SaleRepository saleRepository;
  final VoidCallback? onBackToMenu;

  @override
  State<DailySalesScreen> createState() => _DailySalesScreenState();
}

class _DailySalesScreenState extends State<DailySalesScreen> {
  late DateTime _selectedDate;
  late Future<List<Sale>> _salesFuture;

  @override
  void initState() {
    super.initState();

    _selectedDate = _today();
    _salesFuture = _loadSalesForDate(_selectedDate);
  }

  DateTime _today() {
    final now = DateTime.now();

    return DateTime(now.year, now.month, now.day);
  }

  Future<List<Sale>> _loadSalesForDate(DateTime date) {
    return widget.saleRepository.obtenerVentasDelDia(date);
  }

  void _reloadSelectedDate() {
    setState(() {
      _salesFuture = _loadSalesForDate(_selectedDate);
    });
  }

  void _changeSelectedDate(DateTime date) {
    setState(() {
      _selectedDate = DateTime(date.year, date.month, date.day);
      _salesFuture = _loadSalesForDate(_selectedDate);
    });
  }

  void _goToPreviousDay() {
    _changeSelectedDate(_selectedDate.subtract(const Duration(days: 1)));
  }

  void _goToToday() {
    _changeSelectedDate(_today());
  }

  void _goToNextDay() {
    if (!_canGoToNextDay) {
      return;
    }

    _changeSelectedDate(_selectedDate.add(const Duration(days: 1)));
  }

  bool get _canGoToNextDay {
    return _selectedDate.isBefore(_today());
  }

  void _backToMenu() {
    if (widget.onBackToMenu != null) {
      widget.onBackToMenu!();
      return;
    }

    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoAplicacion,
      body: SafeArea(
        child: FutureBuilder<List<Sale>>(
          future: _salesFuture,
          builder: (context, snapshot) {
            final isLoading =
                snapshot.connectionState == ConnectionState.waiting ||
                snapshot.connectionState == ConnectionState.active;

            final ventas = snapshot.data ?? const <Sale>[];

            final resumen = CalculateDailySalesSummary.ejecutar(
              fecha: _selectedDate,
              ventas: ventas,
            );

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _DailySalesHeader(
                        onBackToMenu: _backToMenu,
                        onRefresh: _reloadSelectedDate,
                      ),
                      const SizedBox(height: 16),
                      _DateNavigationCard(
                        selectedDate: _selectedDate,
                        canGoToNextDay: _canGoToNextDay,
                        onPreviousDay: _goToPreviousDay,
                        onToday: _goToToday,
                        onNextDay: _goToNextDay,
                      ),
                      const SizedBox(height: 16),
                      if (isLoading)
                        const _LoadingSalesCard()
                      else if (snapshot.hasError)
                        _SalesErrorCard(onRetry: _reloadSelectedDate)
                      else ...[
                        _DailySummarySection(summary: resumen),
                        const SizedBox(height: 16),
                        _SalesListSection(sales: ventas),
                      ],
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

class _DailySalesHeader extends StatelessWidget {
  const _DailySalesHeader({
    required this.onBackToMenu,
    required this.onRefresh,
  });

  final VoidCallback onBackToMenu;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FilledButton.icon(
              onPressed: onBackToMenu,
              icon: const Icon(Icons.arrow_back_rounded, size: 20),
              label: const Text('Menú principal'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.verdeOscuro,
                foregroundColor: AppColors.amarilloMaiz,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            const Spacer(),
            IconButton.filledTonal(
              onPressed: onRefresh,
              color: AppColors.verdeOscuro,
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Actualizar ventas',
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Ventas del día',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.verdeOscuro,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Consulta el resumen y las ventas registradas por fecha.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.verdePrincipal,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _DateNavigationCard extends StatelessWidget {
  const _DateNavigationCard({
    required this.selectedDate,
    required this.canGoToNextDay,
    required this.onPreviousDay,
    required this.onToday,
    required this.onNextDay,
  });

  final DateTime selectedDate;
  final bool canGoToNextDay;
  final VoidCallback onPreviousDay;
  final VoidCallback onToday;
  final VoidCallback onNextDay;

  @override
  Widget build(BuildContext context) {
    final isToday = _isSameDate(selectedDate, DateTime.now());

    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              _formatLongDate(selectedDate),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.verdeOscuro,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isToday ? 'Hoy' : _formatWeekday(selectedDate),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isToday ? AppColors.exito : AppColors.verdePrincipal,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
  height: 44,
  child: Row(
    children: [
      Expanded(
        child: FilledButton(
          onPressed: onPreviousDay,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.verdeOscuro,
            foregroundColor: AppColors.amarilloMaiz,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          child: const FittedBox(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.chevron_left_rounded,
                  size: 20,
                ),
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
          onPressed: isToday ? null : onToday,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.verdeOscuro,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            side: const BorderSide(
              color: AppColors.verdePrincipal,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          child: const FittedBox(
            child: Text('Hoy'),
          ),
        ),
      ),
      const SizedBox(width: 8),
            Expanded(
              child: FilledButton(
                onPressed: canGoToNextDay ? onNextDay : null,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.verdeOscuro,
                  foregroundColor: AppColors.amarilloMaiz,
                  disabledBackgroundColor: AppColors.botonDeshabilitado,
                  disabledForegroundColor: AppColors.textoDeshabilitado,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                child: const FittedBox(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Siguiente'),
                      SizedBox(width: 2),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 20,
                      ),
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

class _LoadingSalesCard extends StatelessWidget {
  const _LoadingSalesCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: const Padding(
        padding: EdgeInsets.all(28),
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 14),
            Text('Cargando ventas...'),
          ],
        ),
      ),
    );
  }
}

class _SalesErrorCard extends StatelessWidget {
  const _SalesErrorCard({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.fondoError,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Text(
              'No se pudieron cargar las ventas.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w800,
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

class _DailySummarySection extends StatelessWidget {
  const _DailySummarySection({required this.summary});

  final DailySalesSummary summary;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.tarjetaMenu,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = constraints.maxWidth >= 520
                ? (constraints.maxWidth - 12) / 2
                : constraints.maxWidth;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Resumen del día',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.verdeOscuro,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    SizedBox(
                      width: cardWidth,
                      child: _DailySummaryCard(
                        title: 'Total vendido',
                        value: formatearCentavosComoPesos(
                          summary.totalVendidoCentavos,
                        ),
                        description: 'Solo ventas completadas',
                        highlight: true,
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: _DailySummaryCard(
                        title: 'Ventas completadas',
                        value: summary.ventasCompletadas.toString(),
                        description: summary.ventasCanceladas == 0
                            ? 'Sin cancelaciones'
                            : '${summary.ventasCanceladas} canceladas',
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: _DailySummaryCard(
                        title: 'Dinero recibido',
                        value: formatearCentavosComoPesos(
                          summary.totalRecibidoCentavos,
                        ),
                        description: 'Entradas registradas',
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: _DailySummaryCard(
                        title: 'Cambio entregado',
                        value: formatearCentavosComoPesos(
                          summary.totalCambioCentavos,
                        ),
                        description: 'Cambio total del día',
                      ),
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

class _DailySummaryCard extends StatelessWidget {
  const _DailySummaryCard({
    required this.title,
    required this.value,
    required this.description,
    this.highlight = false,
  });

  final String title;
  final String value;
  final String description;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: highlight ? AppColors.fondoExito : Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: highlight ? AppColors.exito : AppColors.verdePrincipal,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
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
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SalesListSection extends StatelessWidget {
  const _SalesListSection({required this.sales});

  final List<Sale> sales;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: sales.isEmpty
            ? const _EmptySalesMessage()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Ventas registradas',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.verdeOscuro,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (final sale in sales) ...[
                    _SaleCard(sale: sale),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
      ),
    );
  }
}

class _EmptySalesMessage extends StatelessWidget {
  const _EmptySalesMessage();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.fondoAdvertencia,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'No hay ventas registradas para este día.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.advertencia,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _SaleCard extends StatelessWidget {
  const _SaleCard({required this.sale});

  final Sale sale;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.fondoAplicacion,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Venta de las ${_formatTime(sale.fechaHora)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.verdeOscuro,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                _SaleStatusChip(status: sale.estado),
              ],
            ),
            const SizedBox(height: 12),
            _SaleAmountRow(
              label: 'Total',
              value: formatearCentavosComoPesos(sale.totalCentavos),
              highlight: true,
            ),
            const SizedBox(height: 6),
            _SaleAmountRow(
              label: 'Recibido',
              value: formatearCentavosComoPesos(sale.dineroRecibidoCentavos),
            ),
            const SizedBox(height: 6),
            _SaleAmountRow(
              label: 'Cambio',
              value: formatearCentavosComoPesos(sale.cambioCentavos),
            ),
          ],
        ),
      ),
    );
  }
}

class _SaleStatusChip extends StatelessWidget {
  const _SaleStatusChip({required this.status});

  final SaleStatus status;

  @override
  Widget build(BuildContext context) {
    final isCompleted = status == SaleStatus.completada;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isCompleted ? AppColors.fondoExito : AppColors.fondoError,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        status.nombreVisible,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: isCompleted ? AppColors.exito : AppColors.error,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _SaleAmountRow extends StatelessWidget {
  const _SaleAmountRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.verdePrincipal,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.verdeOscuro,
            fontWeight: highlight ? FontWeight.w900 : FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

bool _isSameDate(DateTime first, DateTime second) {
  return first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}

String _formatLongDate(DateTime date) {
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

  return '${date.day} de ${months[date.month - 1]} de ${date.year}';
}

String _formatWeekday(DateTime date) {
  const weekdays = [
    'lunes',
    'martes',
    'miércoles',
    'jueves',
    'viernes',
    'sábado',
    'domingo',
  ];

  return weekdays[date.weekday - 1];
}

String _formatTime(DateTime date) {
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');

  return '$hour:$minute';
}
