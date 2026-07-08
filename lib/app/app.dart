import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import 'router.dart';

class SnacksApp extends StatelessWidget {
  const SnacksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Los de Acá',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.fondoAplicacion,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.verdePrincipal,
          primary: AppColors.verdePrincipal,
          secondary: AppColors.amarilloMaiz,
          surface: AppColors.fondoAplicacion,
        ),
      ),
      initialRoute: AppRoutes.menuPrincipal,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}