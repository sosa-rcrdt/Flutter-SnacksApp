import 'package:flutter/material.dart';

import '../presentation/menu/main_menu_screen.dart';

abstract final class AppRoutes {
  static const String menuPrincipal = '/';
}

abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.menuPrincipal:
        return MaterialPageRoute(
          builder: (_) => const MainMenuScreen(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const MainMenuScreen(),
          settings: settings,
        );
    }
  }
}
