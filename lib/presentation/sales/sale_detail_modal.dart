import 'package:flutter/material.dart';

import '../../core/format/money_format.dart';
import '../../core/theme/app_colors.dart';
import '../../data/repositories/sale_repository.dart';
import '../../domain/models/sale.dart';
import '../../domain/models/sale_detail.dart';
import '../../domain/models/sale_status.dart';

Future<bool?> showSaleDetailModal({
  required BuildContext context,
  required Sale sale,
  required SaleRepository saleRepository,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return _SaleDetailModal(
        sale: sale,
        saleRepository: saleRepository,
      );
    },
  );
}

class _SaleDetailModal extends StatefulWidget {
  const _SaleDetailModal({
    required this.sale,
    required this.saleRepository,
  });

  final Sale sale;
  final SaleRepository saleRepository;

  @override
  State<_SaleDetailModal> createState() => _SaleDetailModalState();
}

class _SaleDetailModalState extends State<_SaleDetailModal> {
  late Future<List<SaleDetail>> _detailsFuture;
  bool _isCancelling = false;

  @override
  void initState() {
    super.initState();
    _detailsFuture = widget.saleRepository.obtenerDetallesDeVenta(
      widget.sale.id,
    );
  }

  Future<void> _cancelSale() async {
    if (_isCancelling || widget.sale.estado == SaleStatus.cancelada) {
      return;
    }

    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cancelar venta'),
          content: const Text(
            'Esta venta ya no sumará al total vendido del día, pero seguirá apareciendo en el historial como cancelada.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Volver'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              child: const Text('Cancelar venta'),
            ),
          ],
        );
      },
    );

    if (shouldCancel != true) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _isCancelling = true;
    });

    try {
      await widget.saleRepository.cancelarVenta(widget.sale.id);

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isCancelling = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo cancelar la venta. Intenta nuevamente.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _close() {
    if (_isCancelling) {
      return;
    }

    Navigator.of(context).pop(false);
  }

  @override
  Widget build(BuildContext context) {
    final isCancelled = widget.sale.estado == SaleStatus.cancelada;

    return SafeArea(
      top: false,
      child: FractionallySizedBox(
        heightFactor: 0.88,
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.fondoAplicacion,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(32),
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _ModalHandle(),
                    const SizedBox(height: 12),
                    _SaleDetailHeader(
                      sale: widget.sale,
                      onClose: _close,
                    ),
                    const SizedBox(height: 16),
                    _SalePaymentSummary(
                      sale: widget.sale,
                    ),
                    const SizedBox(height: 16),
                    _SaleProductsSection(
                      detailsFuture: _detailsFuture,
                      onRetry: () {
                        setState(() {
                          _detailsFuture =
                              widget.saleRepository.obtenerDetallesDeVenta(
                            widget.sale.id,
                          );
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    if (isCancelled)
                      const _CancelledSaleMessage()
                    else
                      _CancelSaleButton(
                        isCancelling: _isCancelling,
                        onCancelSale: _cancelSale,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ModalHandle extends StatelessWidget {
  const _ModalHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 48,
        height: 5,
        decoration: BoxDecoration(
          color: AppColors.botonDeshabilitado,
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}

class _SaleDetailHeader extends StatelessWidget {
  const _SaleDetailHeader({
    required this.sale,
    required this.onClose,
  });

  final Sale sale;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SaleStatusChip(
                status: sale.estado,
              ),
              const SizedBox(height: 12),
              Text(
                'Venta de las ${_formatTime(sale.fechaHora)}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.verdeOscuro,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatLongDate(sale.fechaHora),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.verdePrincipal,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
        IconButton.filledTonal(
          onPressed: onClose,
          color: AppColors.verdeOscuro,
          icon: const Icon(Icons.close_rounded),
          tooltip: 'Cerrar',
        ),
      ],
    );
  }
}

class _SalePaymentSummary extends StatelessWidget {
  const _SalePaymentSummary({
    required this.sale,
  });

  final Sale sale;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _AmountRow(
              label: 'Total',
              value: formatearCentavosComoPesos(sale.totalCentavos),
              highlight: true,
            ),
            const SizedBox(height: 10),
            _AmountRow(
              label: 'Dinero recibido',
              value: formatearCentavosComoPesos(
                sale.dineroRecibidoCentavos,
              ),
            ),
            const SizedBox(height: 10),
            _AmountRow(
              label: 'Cambio entregado',
              value: formatearCentavosComoPesos(sale.cambioCentavos),
            ),
          ],
        ),
      ),
    );
  }
}

class _SaleProductsSection extends StatelessWidget {
  const _SaleProductsSection({
    required this.detailsFuture,
    required this.onRetry,
  });

  final Future<List<SaleDetail>> detailsFuture;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SaleDetail>>(
      future: detailsFuture,
      builder: (context, snapshot) {
        final isLoading = snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.active;

        if (isLoading) {
          return Card(
            color: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 14),
                  Text('Cargando detalle...'),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Card(
            color: AppColors.fondoError,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Text(
                    'No se pudo cargar el detalle de la venta.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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

        final details = snapshot.data ?? const <SaleDetail>[];

        return Card(
          color: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: details.isEmpty
                ? Text(
                    'Esta venta no tiene productos registrados.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.advertencia,
                          fontWeight: FontWeight.w800,
                        ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Productos vendidos',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppColors.verdeOscuro,
                                  fontWeight: FontWeight.w900,
                                ),
                      ),
                      const SizedBox(height: 12),
                      for (final detail in details) ...[
                        _SaleDetailProductCard(
                          detail: detail,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class _SaleDetailProductCard extends StatelessWidget {
  const _SaleDetailProductCard({
    required this.detail,
  });

  final SaleDetail detail;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.fondoAplicacion,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    detail.nombreProductoSnapshot,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.verdeOscuro,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${detail.cantidad} x ${formatearCentavosComoPesos(detail.precioUnitarioCentavosSnapshot)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.verdePrincipal,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              formatearCentavosComoPesos(detail.subtotalCentavos),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.verdeOscuro,
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CancelSaleButton extends StatelessWidget {
  const _CancelSaleButton({
    required this.isCancelling,
    required this.onCancelSale,
  });

  final bool isCancelling;
  final VoidCallback onCancelSale;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isCancelling ? null : onCancelSale,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.error,
        minimumSize: const Size.fromHeight(48),
        side: const BorderSide(
          color: AppColors.error,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 16,
        ),
      ),
      child: isCancelling
          ? const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                  ),
                ),
                SizedBox(width: 10),
                Text('Cancelando venta...'),
              ],
            )
          : const Text('Cancelar venta'),
    );
  }
}

class _CancelledSaleMessage extends StatelessWidget {
  const _CancelledSaleMessage();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.fondoError,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Text(
          'Esta venta está cancelada. No suma al total vendido del día.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
    );
  }
}

class _SaleStatusChip extends StatelessWidget {
  const _SaleStatusChip({
    required this.status,
  });

  final SaleStatus status;

  @override
  Widget build(BuildContext context) {
    final isCompleted = status == SaleStatus.completada;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: isCompleted ? AppColors.fondoExito : AppColors.fondoError,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          status.nombreVisible,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isCompleted ? AppColors.exito : AppColors.error,
                fontWeight: FontWeight.w900,
              ),
        ),
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow({
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
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.verdePrincipal,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        const SizedBox(width: 16),
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

String _formatTime(DateTime date) {
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');

  return '$hour:$minute';
}