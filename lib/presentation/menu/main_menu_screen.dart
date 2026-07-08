import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoAplicacion,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _MainLogo(),
                  SizedBox(height: 8),
                  _MainDescription(),
                  SizedBox(height: 32),
                  _MainMenuCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MainLogo extends StatelessWidget {
  const _MainLogo();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo_los_de_aca.png',
      height: 220,
      width: double.infinity,
      fit: BoxFit.contain,
      semanticLabel: 'Logo de Los de Acá',
    );
  }
}

class _MainDescription extends StatelessWidget {
  const _MainDescription();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Sistema de ventas para elotes y snacks',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: AppColors.verdePrincipal,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _MainMenuCard extends StatelessWidget {
  const _MainMenuCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.tarjetaMenu,
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Menú principal',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.verdeOscuro,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'La pantalla de compra se agregará en un próximo commit.',
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.amarilloMaiz,
                foregroundColor: AppColors.verdeOscuro,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              child: const Text('Calcular compra'),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: null,
              style: FilledButton.styleFrom(
                disabledBackgroundColor: AppColors.botonDeshabilitado,
                disabledForegroundColor: AppColors.textoDeshabilitado,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              child: const Text('Ventas del día'),
            ),
          ],
        ),
      ),
    );
  }
}
