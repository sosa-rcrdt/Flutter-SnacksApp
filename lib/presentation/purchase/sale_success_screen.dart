import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class SaleSuccessScreen extends StatefulWidget {
  const SaleSuccessScreen({
    super.key,
    required this.onGoToMenu,
    required this.onStartNewPurchase,
  });

  final VoidCallback onGoToMenu;
  final VoidCallback onStartNewPurchase;

  @override
  State<SaleSuccessScreen> createState() => _SaleSuccessScreenState();
}

class _SaleSuccessScreenState extends State<SaleSuccessScreen>
    with TickerProviderStateMixin {
  late final AnimationController _progressController;
  late final AnimationController _checkController;

  bool _completed = false;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );

    _progressController.addStatusListener((status) {
      if (status != AnimationStatus.completed) {
        return;
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _completed = true;
      });

      _checkController.forward();
    });

    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoAplicacion,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Card(
                color: Colors.white,
                elevation: 4,
                shadowColor: Colors.black.withValues(alpha: 0.14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _SuccessAnimation(
                        progressController: _progressController,
                        checkController: _checkController,
                        completed: _completed,
                      ),
                      const SizedBox(height: 28),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 260),
                        child: Text(
                          _completed
                              ? 'Operación realizada correctamente'
                              : 'Finalizando operación...',
                          key: ValueKey(_completed),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: AppColors.verdeOscuro,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 260),
                        child: Text(
                          _completed
                              ? 'La venta se guardó en el sistema.'
                              : 'Estamos registrando la venta.',
                          key: ValueKey('description-$_completed'),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.verdePrincipal,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      AnimatedOpacity(
                        opacity: _completed ? 1 : 0,
                        duration: const Duration(milliseconds: 260),
                        child: IgnorePointer(
                          ignoring: !_completed,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              FilledButton(
                                onPressed: widget.onStartNewPurchase,
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.amarilloMaiz,
                                  foregroundColor: AppColors.verdeOscuro,
                                  minimumSize: const Size.fromHeight(48),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                                child: const Text('Nueva compra'),
                              ),
                              const SizedBox(height: 10),
                              OutlinedButton(
                                onPressed: widget.onGoToMenu,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.verdeOscuro,
                                  minimumSize: const Size.fromHeight(48),
                                  side: const BorderSide(
                                    color: AppColors.verdePrincipal,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                child: const Text('Menú principal'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SuccessAnimation extends StatelessWidget {
  const _SuccessAnimation({
    required this.progressController,
    required this.checkController,
    required this.completed,
  });

  final AnimationController progressController;
  final AnimationController checkController;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 112,
      height: 112,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 240),
        child: completed
            ? AnimatedBuilder(
                key: const ValueKey('success-check'),
                animation: checkController,
                builder: (context, child) {
                  final scale = Curves.easeOutBack.transform(
                    checkController.value,
                  );

                  return Transform.scale(scale: scale, child: child);
                },
                child: Container(
                  width: 104,
                  height: 104,
                  decoration: const BoxDecoration(
                    color: AppColors.exito,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 68,
                  ),
                ),
              )
            : AnimatedBuilder(
                key: const ValueKey('success-loading'),
                animation: progressController,
                builder: (context, child) {
                  return CircularProgressIndicator(
                    value: progressController.value,
                    strokeWidth: 7,
                    color: AppColors.verdePrincipal,
                    backgroundColor: AppColors.fondoExito,
                  );
                },
              ),
      ),
    );
  }
}
