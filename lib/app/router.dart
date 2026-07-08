import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../data/repositories/sale_repository.dart';
import '../domain/models/cart_summary.dart';
import '../domain/models/product.dart';
import '../presentation/menu/main_menu_screen.dart';
import '../presentation/purchase/product_selection_screen.dart';
import '../presentation/purchase/purchase_summary_screen.dart';

abstract final class AppRoutes {
  static const String menuPrincipal = '/';
  static const String seleccionProductos = '/seleccion-productos';
  static const String resumenCompra = '/resumen-compra';
}

class PurchaseSummaryRouteArguments {
  final List<Product> products;
  final Map<int, int> quantitiesByProduct;
  final CartSummary cartSummary;

  const PurchaseSummaryRouteArguments({
    required this.products,
    required this.quantitiesByProduct,
    required this.cartSummary,
  });
}

abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(
    RouteSettings settings, {
    required SaleRepository saleRepository,
  }) {
    switch (settings.name) {
      case AppRoutes.menuPrincipal:
        return _buildSlideRoute(
          settings: settings,
          childBuilder: (context) => MainMenuScreen(
            onStartPurchase: () {
              Navigator.of(context).pushNamed(AppRoutes.seleccionProductos);
            },
          ),
        );

      case AppRoutes.seleccionProductos:
        return _buildSlideRoute(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 360),
          curve: Curves.easeOutQuart,
          childBuilder: (context) => ProductSelectionScreen(
            onBack: () {
              Navigator.of(context).maybePop();
            },
            onGoToSummary: ({
              required products,
              required quantitiesByProduct,
              required cartSummary,
            }) {
              Navigator.of(context).pushNamed(
                AppRoutes.resumenCompra,
                arguments: PurchaseSummaryRouteArguments(
                  products: products,
                  quantitiesByProduct: quantitiesByProduct,
                  cartSummary: cartSummary,
                ),
              );
            },
          ),
        );

      case AppRoutes.resumenCompra:
        final arguments = settings.arguments;

        if (arguments is! PurchaseSummaryRouteArguments) {
          return _buildSlideRoute(
            settings: settings,
            childBuilder: (_) => const _NavigationErrorScreen(
              message: 'No se pudo abrir el resumen de compra.',
            ),
          );
        }

        return _buildSlideRoute(
          settings: settings,
          childBuilder: (context) => PurchaseSummaryScreen(
            products: arguments.products,
            quantitiesByProduct: arguments.quantitiesByProduct,
            cartSummary: arguments.cartSummary,
            onBackToProducts: () {
              Navigator.of(context).maybePop();
            },
            onConfirmSale: ({
              required paymentSummary,
            }) async {
              final saleId = await saleRepository.guardarVentaCompletada(
                productos: arguments.products,
                cantidadesPorProducto: arguments.quantitiesByProduct,
                resumenCarrito: arguments.cartSummary,
                resumenCobro: paymentSummary,
              );

              if (!context.mounted) {
                return;
              }

              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);

              navigator.popUntil(
                (route) => route.settings.name == AppRoutes.menuPrincipal,
              );

              messenger.showSnackBar(
                SnackBar(
                  content: Text('Venta #$saleId guardada correctamente.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        );

      default:
        return _buildSlideRoute(
          settings: settings,
          childBuilder: (_) => const _NavigationErrorScreen(
            message: 'La pantalla solicitada no existe.',
          ),
        );
    }
  }

  static PageRouteBuilder<dynamic> _buildSlideRoute({
    required RouteSettings settings,
    required WidgetBuilder childBuilder,
    Duration transitionDuration = const Duration(milliseconds: 260),
    Duration reverseTransitionDuration = const Duration(milliseconds: 220),
    Curve curve = Curves.easeOutCubic,
    Curve reverseCurve = Curves.easeInCubic,
  }) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
      pageBuilder: (context, animation, secondaryAnimation) {
        return childBuilder(context);
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
          reverseCurve: reverseCurve,
        );

        final slideAnimation = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(curvedAnimation);

        return SlideTransition(
          position: slideAnimation,
          child: child,
        );
      },
    );
  }
}

class _NavigationErrorScreen extends StatelessWidget {
  const _NavigationErrorScreen({
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoAplicacion,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.verdeOscuro,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}