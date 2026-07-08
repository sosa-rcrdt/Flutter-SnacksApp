String formatearCentavosComoPesos(int centavos) {
  final esNegativo = centavos < 0;
  final valorAbsoluto = centavos.abs();

  final pesos = valorAbsoluto ~/ 100;
  final centavosRestantes = valorAbsoluto % 100;
  final centavosTexto = centavosRestantes.toString().padLeft(2, '0');

  return '${esNegativo ? '-' : ''}\$$pesos.$centavosTexto';
}