import 'dart:async';

import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../data/database/app_database.dart';
import '../data/repositories/sale_repository.dart';
import 'router.dart';

class SnacksApp extends StatefulWidget {
  const SnacksApp({super.key});

  @override
  State<SnacksApp> createState() => _SnacksAppState();
}

class _SnacksAppState extends State<SnacksApp> {
  late final AppDatabase _database;
  late final SaleRepository _saleRepository;

  @override
  void initState() {
    super.initState();

    _database = AppDatabase();
    _saleRepository = SaleRepository(_database);
  }

  @override
  void dispose() {
    unawaited(_database.close());
    super.dispose();
  }

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
      onGenerateRoute: (settings) {
        return AppRouter.onGenerateRoute(
          settings,
          saleRepository: _saleRepository,
        );
      },
    );
  }
}
