import 'package:flutter/material.dart';

import '../../core/format/money_format.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/models/product.dart';
import '../../domain/models/product_category.dart';

class ProductSelectionScreen extends StatelessWidget {
  const ProductSelectionScreen({
    super.key,
    this.products,
    this.quantitiesByProduct = const {},
    this.onBack,
    this.onIncreaseQuantity,
    this.onDecreaseQuantity,
    this.onGoToSummary,
  });

  final List<Product>? products;
  final Map<int, int> quantitiesByProduct;
  final VoidCallback? onBack;
  final ValueChanged<Product>? onIncreaseQuantity;
  final ValueChanged<Product>? onDecreaseQuantity;
  final VoidCallback? onGoToSummary;

  @override
  Widget build(BuildContext context) {
    final productsToShow = products ?? _sampleProductsForLayout();

    return Scaffold(
      backgroundColor: AppColors.fondoAplicacion,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _PurchaseHeader(
                  onBack: () {
                    if (onBack != null) {
                      onBack!();
                      return;
                    }

                    Navigator.of(context).maybePop();
                  },
                ),
                const SizedBox(height: 16),
                _ProductCatalogSection(
                  products: productsToShow,
                  quantitiesByProduct: quantitiesByProduct,
                  onIncreaseQuantity: onIncreaseQuantity,
                  onDecreaseQuantity: onDecreaseQuantity,
                ),
                const SizedBox(height: 16),
                const _PartialSummaryCard(),
                const SizedBox(height: 16),
                _GoToSummaryButton(
                  enabled: false,
                  onPressed: onGoToSummary,
                ),
              ],
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
          child: const Text('Menú principal'),
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
  final ValueChanged<Product>? onIncreaseQuantity;
  final ValueChanged<Product>? onDecreaseQuantity;

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
              'Productos',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.verdeOscuro,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Catálogo disponible para registrar una compra.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.verdePrincipal,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 16),
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
                if (index < products.length - 1) const SizedBox(height: 10),
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
  final ValueChanged<Product>? onIncreaseQuantity;
  final ValueChanged<Product>? onDecreaseQuantity;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const _GenericProductImage(),
            const SizedBox(width: 12),
            Expanded(
              child: _ProductInfo(product: product),
            ),
            const SizedBox(width: 12),
            _QuantityControls(
              quantity: quantity,
              canDecrease: quantity > 0 && onDecreaseQuantity != null,
              canIncrease: onIncreaseQuantity != null,
              onDecrease: () => onDecreaseQuantity?.call(product),
              onIncrease: () => onIncreaseQuantity?.call(product),
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
        width: 58,
        height: 58,
        child: Center(
          child: Text(
            '🌽',
            style: TextStyle(fontSize: 28),
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
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.verdeOscuro,
                fontWeight: FontWeight.w800,
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
              ),
        ),
        const SizedBox(height: 4),
        Text(
          formatearCentavosComoPesos(product.precioCentavos),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.verdeOscuro,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}

class _QuantityControls extends StatelessWidget {
  const _QuantityControls({
    required this.quantity,
    required this.canDecrease,
    required this.canIncrease,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int quantity;
  final bool canDecrease;
  final bool canIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _QuantityButton(
          text: '-',
          enabled: canDecrease,
          onPressed: onDecrease,
        ),
        SizedBox(
          width: 36,
          child: Text(
            quantity.toString(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.verdeOscuro,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ),
        _QuantityButton(
          text: '+',
          enabled: canIncrease,
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
        minimumSize: const Size(36, 36),
        fixedSize: const Size(36, 36),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 16,
        ),
      ),
      child: Text(text),
    );
  }
}

class _PartialSummaryCard extends StatelessWidget {
  const _PartialSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _PartialSummaryTitle(),
            SizedBox(height: 10),
            _PartialSummaryRow(
              label: 'Productos agregados',
              value: '0',
            ),
            SizedBox(height: 6),
            _PartialSummaryRow(
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
    required this.onPressed,
  });

  final bool enabled;
  final VoidCallback? onPressed;

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
      child: const Text('Ver resumen de compra'),
    );
  }
}

List<Product> _sampleProductsForLayout() {
  return [
    Product(
      id: 1,
      nombre: 'Elote',
      precioCentavos: 3000,
      categoria: ProductCategory.elotesYEsquites,
    ),
    Product(
      id: 2,
      nombre: 'Esquite mediano',
      precioCentavos: 3500,
      categoria: ProductCategory.elotesYEsquites,
    ),
    Product(
      id: 3,
      nombre: 'Doriesquite',
      precioCentavos: 6000,
      categoria: ProductCategory.snacksPreparados,
    ),
    Product(
      id: 4,
      nombre: 'Arizona preparado',
      precioCentavos: 4000,
      categoria: ProductCategory.bebidas,
    ),
  ];
}