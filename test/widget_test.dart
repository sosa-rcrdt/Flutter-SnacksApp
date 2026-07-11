import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snacks/presentation/menu/main_menu_screen.dart';

void main() {
  testWidgets('Muestra el menú principal de Los de Acá', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainMenuScreen()));

    expect(find.text('Sistema de ventas para elotes y snacks'), findsOneWidget);
    expect(find.text('Menú principal'), findsOneWidget);
    expect(find.text('Calcular compra'), findsOneWidget);
    expect(find.text('Ventas del día'), findsOneWidget);
  });
}
