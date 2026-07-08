import 'package:flutter/material.dart';

import '../../core/format/money_format.dart';
import '../../core/theme/app_colors.dart';
import '../../data/local/local_product_catalog.dart';
import '../../domain/models/product.dart';

class ProductSelectionScreen extends StatefulWidget {
  const ProductSelectionScreen({
    super.key,
    this.products,
    this.initialQuantitiesByProduct = const {},
    this.onBack,
    this.onGoToSummary,
  });

  final List<Product>? products;
  final Map<int, int> initialQuantitiesByProduct;
  final VoidCallback? onBack;
  final VoidCallback? onGoToSummary;

  @override
  State<ProductSelectionScreen> createState() => _ProductSelectionScreenState();
}

class _ProductSelectionScreenState extends State<ProductSelectionScreen> {
  late final List<Product> _products;
  late final Map<int, int> _quantitiesByProduct;

  @override
  void initState() {
    super.initState();

    _products = widget.products ?? LocalProductCatalog.obtenerProductosActivos();
    _quantitiesByProduct = Map<int, int>.from(widget.initialQuantitiesByProduct)
      ..removeWhere((_, quantity) => quantity <= 0);
  }

  int get _totalProductCount {
    return _quantitiesByProduct.values.fold(
      0,
      (total, quantity) => total + quantity,
    );
  }

  void _increaseQuantity(Product product) {
    setState(() {
      final currentQuantity = _quantitiesByProduct[product.id] ?? 0;
      _quantitiesByProduct[product.id] = currentQuantity + 1;
    });
  }

  void _decreaseQuantity(Product product) {
    final currentQuantity = _quantitiesByProduct[product.id] ?? 0;

    if (currentQuantity <= 0) {
      return;
    }

    setState(() {
      final newQuantity = currentQuantity - 1;

      if (newQuantity == 0) {
        _quantitiesByProduct.remove(product.id);
      } else {
        _quantitiesByProduct[product.id] = newQuantity;
      }
    });
  }

  void _goBack() {
    if (widget.onBack != null) {
      widget.onBack!();
      return;
    }

    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
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
                  _PurchaseHeader(
                    onBack: _goBack,
                  ),
                  const SizedBox(height: 16),
                  _ProductCatalogSection(
                    products: _products,
                    quantitiesByProduct: _quantitiesByProduct,
                    onIncreaseQuantity: _increaseQuantity,
                    onDecreaseQuantity: _decreaseQuantity,
                  ),
                  const SizedBox(height: 16),
                  _PartialSummaryCard(
                    totalProductCount: _totalProductCount,
                  ),
                  const SizedBox(height: 16),
                  _GoToSummaryButton(
                    enabled: false,
                    productCount: _totalProductCount,
                    onPressed: widget.onGoToSummary,
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

class _PurchaseHeader extends StatelessWidget {
  const _PurchaseHeader({
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilledButton(
          onPressed: onBack,
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
          child: const Text('← Menú principal'),
        ),
        const SizedBox(height: 16),
        Text(
          'Seleccionar productos',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.verdeOscuro,
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Agrega al carrito los productos que se venderán.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.verdePrincipal,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}

class _ProductCatalogSection extends StatelessWidget {
  const _ProductCatalogSection({
    required this.products,
    required this.quantitiesByProduct,
    required this.onIncreaseQuantity,
    required this.onDecreaseQuantity,
  });

  final List<Product> products;
  final Map<int, int> quantitiesByProduct;
  final ValueChanged<Product> onIncreaseQuantity;
  final ValueChanged<Product> onDecreaseQuantity;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.tarjetaMenu,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Productos',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.verdeOscuro,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 3),
            Text(
              'Catálogo disponible para registrar una compra.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.verdePrincipal,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
            ),
            const SizedBox(height: 14),
            if (products.isEmpty)
              const _EmptyCatalogMessage()
            else
              for (var index = 0; index < products.length; index++) ...[
                _ProductPurchaseCard(
                  product: products[index],
                  quantity: quantitiesByProduct[products[index].id] ?? 0,
                  onIncreaseQuantity: onIncreaseQuantity,
                  onDecreaseQuantity: onDecreaseQuantity,
                ),
                if (index < products.length - 1) const SizedBox(height: 8),
              ],
          ],
        ),
      ),
    );
  }
}

class _EmptyCatalogMessage extends StatelessWidget {
  const _EmptyCatalogMessage();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Todavía no hay productos disponibles.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.verdePrincipal,
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
    );
  }
}

class _ProductPurchaseCard extends StatelessWidget {
  const _ProductPurchaseCard({
    required this.product,
    required this.quantity,
    required this.onIncreaseQuantity,
    required this.onDecreaseQuantity,
  });

  final Product product;
  final int quantity;
  final ValueChanged<Product> onIncreaseQuantity;
  final ValueChanged<Product> onDecreaseQuantity;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const _GenericProductImage(),
            const SizedBox(width: 10),
            Expanded(
              child: _ProductInfo(product: product),
            ),
            const SizedBox(width: 8),
            _QuantityControls(
              quantity: quantity,
              onDecrease: () => onDecreaseQuantity(product),
              onIncrease: () => onIncreaseQuantity(product),
            ),
          ],
        ),
      ),
    );
  }
}

class _GenericProductImage extends StatelessWidget {
  const _GenericProductImage();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.fondoAplicacion,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: const SizedBox(
        width: 50,
        height: 50,
        child: Center(
          child: Text(
            '🌽',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}

class _ProductInfo extends StatelessWidget {
  const _ProductInfo({
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.nombre,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.verdeOscuro,
                fontWeight: FontWeight.w800,
                fontSize: 14,
                height: 1.12,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          product.categoria.nombreVisible,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.verdePrincipal,
                fontWeight: FontWeight.w500,
                fontSize: 11,
                height: 1.1,
              ),
        ),
        const SizedBox(height: 3),
        Text(
          formatearCentavosComoPesos(product.precioCentavos),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.verdeOscuro,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
        ),
      ],
    );
  }
}

class _QuantityControls extends StatelessWidget {
  const _QuantityControls({
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _QuantityButton(
          text: '-',
          enabled: quantity > 0,
          onPressed: onDecrease,
        ),
        SizedBox(
          width: 30,
          child: Text(
            quantity.toString(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.verdeOscuro,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
          ),
        ),
        _QuantityButton(
          text: '+',
          enabled: true,
          onPressed: onIncrease,
        ),
      ],
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.text,
    required this.enabled,
    required this.onPressed,
  });

  final String text;
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
        minimumSize: const Size(32, 32),
        fixedSize: const Size(32, 32),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 15,
        ),
      ),
      child: Text(text),
    );
  }
}

class _PartialSummaryCard extends StatelessWidget {
  const _PartialSummaryCard({
    required this.totalProductCount,
  });

  final int totalProductCount;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const _PartialSummaryTitle(),
            const SizedBox(height: 10),
            _PartialSummaryRow(
              label: 'Productos agregados',
              value: totalProductCount.toString(),
            ),
            const SizedBox(height: 6),
            const _PartialSummaryRow(
              label: 'Total parcial',
              value: r'$0.00',
            ),
          ],
        ),
      ),
    );
  }
}

class _PartialSummaryTitle extends StatelessWidget {
  const _PartialSummaryTitle();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Carrito actual',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.verdeOscuro,
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}

class _PartialSummaryRow extends StatelessWidget {
  const _PartialSummaryRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

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
                fontWeight: FontWeight.w800,
              ),
        ),
      ],
    );
  }
}

class _GoToSummaryButton extends StatelessWidget {
  const _GoToSummaryButton({
    required this.enabled,
    required this.productCount,
    required this.onPressed,
  });

  final bool enabled;
  final int productCount;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final buttonText = productCount > 0
        ? 'Ver resumen de compra ($productCount)'
        : 'Ver resumen de compra';

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
      child: Text(buttonText),
    );
  }
}