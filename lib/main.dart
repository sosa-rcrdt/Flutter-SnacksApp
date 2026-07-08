import 'package:flutter/material.dart';

void main() {
  runApp(const SnacksApp());
}

class SnacksApp extends StatelessWidget {
  const SnacksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Los de Acá',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: ColoresMarca.fondoAplicacion,
        colorScheme: ColorScheme.fromSeed(
          seedColor: ColoresMarca.verdePrincipal,
          primary: ColoresMarca.verdePrincipal,
          secondary: ColoresMarca.amarilloMaiz,
          surface: ColoresMarca.fondoAplicacion,
        ),
      ),
      home: const PantallaMenuPrincipal(),
    );
  }
}

class PantallaMenuPrincipal extends StatelessWidget {
  const PantallaMenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresMarca.fondoAplicacion,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const LogoPrincipal(),

                  const SizedBox(height: 8),

                  Text(
                    'Sistema de ventas para elotes y snacks',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: ColoresMarca.verdePrincipal,
                          fontWeight: FontWeight.w500,
                        ),
                  ),

                  const SizedBox(height: 32),

                  const TarjetaMenuPrincipal(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LogoPrincipal extends StatelessWidget {
  const LogoPrincipal({super.key});

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

class TarjetaMenuPrincipal extends StatelessWidget {
  const TarjetaMenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColoresMarca.tarjetaMenu,
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Menú principal',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: ColoresMarca.verdeOscuro,
                    fontWeight: FontWeight.w700,
                  ),
            ),

            const SizedBox(height: 16),

            FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('La pantalla de compra se agregará en un próximo commit.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: ColoresMarca.amarilloMaiz,
                foregroundColor: ColoresMarca.verdeOscuro,
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
                disabledBackgroundColor: ColoresMarca.botonDeshabilitado,
                disabledForegroundColor: ColoresMarca.textoDeshabilitado,
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

class ColoresMarca {
  static const Color fondoAplicacion = Color(0xFFFFFBF3);
  static const Color verdePrincipal = Color(0xFF1F5E1F);
  static const Color verdeOscuro = Color(0xFF0B2E13);
  static const Color amarilloMaiz = Color(0xFFFFC928);
  static const Color tarjetaMenu = Color(0xFFFFF4D8);
  static const Color botonDeshabilitado = Color(0xFFE3DDD0);
  static const Color textoDeshabilitado = Color(0xFF8C867B);
}