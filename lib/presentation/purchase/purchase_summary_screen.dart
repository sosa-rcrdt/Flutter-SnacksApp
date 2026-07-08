import 'package:flutter/material.dart';

import '../../core/format/money_format.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/models/cart_summary.dart';
import '../../domain/models/payment_summary.dart';
import '../../domain/models/payment_validation_message.dart';
import '../../domain/models/product.dart';
import '../../domain/use_cases/calculate_payment_summary.dart';
import '../../domain/use_cases/calculate_payment_validation_message.dart';

class PurchaseSummaryScreen extends StatefulWidget {
  const PurchaseSummaryScreen({
    super.key,
    required this.products,
    required this.quantitiesByProduct,
    required this.cartSummary,
    this.onBackToProducts,
    this.onConfirmSale,
  });

  final List<Product> products;
  final Map<int, int> quantitiesByProduct;
  final CartSummary cartSummary;
  final VoidCallback? onBackToProducts;
  final VoidCallback? onConfirmSale;

  @override
  State<PurchaseSummaryScreen> createState() => _PurchaseSummaryScreenState();
}

class _PurchaseSummaryScreenState extends State<PurchaseSummaryScreen> {
  final TextEditingController _receivedAmountController =
      TextEditingController();

  @override
  void dispose() {
    _receivedAmountController.dispose();
    super.dispose();
  }

  List<Product> get _selectedProducts {
    return widget.products.where((product) {
      final quantity = widget.quantitiesByProduct[product.id] ?? 0;
      return quantity > 0;
    }).toList();
  }

  void _backToProducts() {
    if (widget.onBackToProducts != null) {
      widget.onBackToProducts!();
      return;
    }

    Navigator.of(context).maybePop();
  }

  void _confirmSale() {
    if (widget.onConfirmSale != null) {
      widget.onConfirmSale!();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'La venta se guardará cuando agreguemos persistencia local.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dineroRecibidoCentavos = convertirTextoPesosACentavos(
      _receivedAmountController.text,
    );

    final paymentSummary = CalculatePaymentSummary.ejecutar(
      cartSummary: widget.cartSummary,
      dineroRecibidoCentavos: dineroRecibidoCentavos,
    );

    final validationMessage = CalculatePaymentValidationMessage.ejecutar(
      textoDineroRecibido: _receivedAmountController.text,
      cartSummary: widget.cartSummary,
      paymentSummary: paymentSummary,
    );

    return Scaffold(
      backgroundColor: AppColors.fondoAplicacion,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SummaryHeader(
                    onBackToProducts: _backToProducts,
                  ),
                  const SizedBox(height: 16),
                  _SelectedProductsSection(
                    selectedProducts: _selectedProducts,
                    quantitiesByProduct: widget.quantitiesByProduct,
                    cartSummary: widget.cartSummary,
                  ),
                  const SizedBox(height: 16),
                  _PaymentSection(
                    controller: _receivedAmountController,
                    paymentSummary: paymentSummary,
                    validationMessage: validationMessage,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  _ConfirmSaleButton(
                    enabled: paymentSummary.pagoSuficiente,
                    onPressed: _confirmSale,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryHeader extends StatelessWidget {
  const _SummaryHeader({
    required this.onBackToProducts,
  });

  final VoidCallback onBackToProducts;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilledButton(
          onPressed: onBackToProducts,
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
            textStyle: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          child: const Text('← Productos'),
        ),
        const SizedBox(height: 16),
        Text(
          'Resumen de compra',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.verdeOscuro,
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Revisa los productos seleccionados y calcula el cambio.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.verdePrincipal,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}

class _SelectedProductsSection extends StatelessWidget {
  const _SelectedProductsSection({
    required this.selectedProducts,
    required this.quantitiesByProduct,
    required this.cartSummary,
  });

  final List<Product> selectedProducts;
  final Map<int, int> quantitiesByProduct;
  final CartSummary cartSummary;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.tarjetaMenu,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Productos seleccionados',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.verdeOscuro,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 12),
            if (selectedProducts.isEmpty)
              const _EmptySummaryMessage()
            else
              for (final product in selectedProducts) ...[
                _SelectedProductRow(
                  product: product,
                  quantity: quantitiesByProduct[product.id] ?? 0,
                ),
                const SizedBox(height: 8),
              ],
            const SizedBox(height: 8),
            _SummaryRow(
              label: 'Productos',
              value: cartSummary.cantidadTotalProductos.toString(),
            ),
            const SizedBox(height: 6),
            _SummaryRow(
              label: 'Total',
              value: formatearCentavosComoPesos(cartSummary.totalCentavos),
              highlight: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptySummaryMessage extends StatelessWidget {
  const _EmptySummaryMessage();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.fondoAdvertencia,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Text(
          'No hay productos seleccionados.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.advertencia,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}

class _SelectedProductRow extends StatelessWidget {
  const _SelectedProductRow({
    required this.product,
    required this.quantity,
  });

  final Product product;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    final subtotalCentavos = product.precioCentavos * quantity;

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.nombre,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.verdeOscuro,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$quantity x ${formatearCentavosComoPesos(product.precioCentavos)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.verdePrincipal,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              formatearCentavosComoPesos(subtotalCentavos),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.verdeOscuro,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentSection extends StatelessWidget {
  const _PaymentSection({
    required this.controller,
    required this.paymentSummary,
    required this.validationMessage,
    required this.onChanged,
  });

  final TextEditingController controller;
  final PaymentSummary paymentSummary;
  final PaymentValidationMessage validationMessage;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final dineroRecibidoTexto = paymentSummary.dineroRecibidoValido
        ? formatearCentavosComoPesos(paymentSummary.dineroRecibidoCentavos!)
        : '—';

    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Cobro',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.verdeOscuro,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              onChanged: onChanged,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'Dinero recibido',
                hintText: 'Ej. 200',
                filled: true,
                fillColor: AppColors.fondoAplicacion,
                errorText: controller.text.trim().isNotEmpty &&
                        !paymentSummary.dineroRecibidoValido
                    ? 'Cantidad no válida'
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _ValidationMessageCard(
              message: validationMessage,
            ),
            const SizedBox(height: 16),
            _SummaryRow(
              label: 'Total a pagar',
              value: formatearCentavosComoPesos(paymentSummary.totalCentavos),
            ),
            const SizedBox(height: 8),
            _SummaryRow(
              label: 'Dinero recibido',
              value: dineroRecibidoTexto,
            ),
            const SizedBox(height: 8),
            _SummaryRow(
              label: 'Falta por cubrir',
              value: formatearCentavosComoPesos(
                paymentSummary.faltanteCentavos,
              ),
            ),
            const SizedBox(height: 8),
            _SummaryRow(
              label: 'Cambio a entregar',
              value: formatearCentavosComoPesos(
                paymentSummary.cambioCentavos,
              ),
              highlight: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _ValidationMessageCard extends StatelessWidget {
  const _ValidationMessageCard({
    required this.message,
  });

  final PaymentValidationMessage message;

  @override
  Widget build(BuildContext context) {
    final colors = _ValidationMessageColors.fromType(message.tipo);

    return Card(
      color: colors.backgroundColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              colors.icon,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colors.foregroundColor,
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.titulo,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colors.foregroundColor,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message.descripcion,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.foregroundColor,
                          fontWeight: FontWeight.w500,
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

class _ValidationMessageColors {
  final Color backgroundColor;
  final Color foregroundColor;
  final String icon;

  const _ValidationMessageColors({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.icon,
  });

  factory _ValidationMessageColors.fromType(PaymentValidationType type) {
    return switch (type) {
      PaymentValidationType.success => const _ValidationMessageColors(
          backgroundColor: AppColors.fondoExito,
          foregroundColor: AppColors.exito,
          icon: '✓',
        ),
      PaymentValidationType.warning => const _ValidationMessageColors(
          backgroundColor: AppColors.fondoAdvertencia,
          foregroundColor: AppColors.advertencia,
          icon: '!',
        ),
      PaymentValidationType.error => const _ValidationMessageColors(
          backgroundColor: AppColors.fondoError,
          foregroundColor: AppColors.error,
          icon: '×',
        ),
    };
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
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
                  fontWeight: FontWeight.w500,
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

class _ConfirmSaleButton extends StatelessWidget {
  const _ConfirmSaleButton({
    required this.enabled,
    required this.onPressed,
  });

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: enabled ? onPressed : null,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.amarilloMaiz,
        foregroundColor: AppColors.verdeOscuro,
        disabledBackgroundColor: AppColors.botonDeshabilitado,
        disabledForegroundColor: AppColors.textoDeshabilitado,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 16,
        ),
      ),
      child: const Text('Confirmar venta'),
    );
  }
}