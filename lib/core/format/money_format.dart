String formatearCentavosComoPesos(int centavos) {
  final esNegativo = centavos < 0;
  final valorAbsoluto = centavos.abs();

  final pesos = valorAbsoluto ~/ 100;
  final centavosRestantes = valorAbsoluto % 100;
  final centavosTexto = centavosRestantes.toString().padLeft(2, '0');

  return '${esNegativo ? '-' : ''}\$$pesos.$centavosTexto';
}

int? convertirTextoPesosACentavos(String texto) {
  final textoLimpio = texto.trim().replaceAll(',', '.');

  if (textoLimpio.isEmpty) {
    return null;
  }

  final expresionValida = RegExp(r'^\d+(\.\d{1,2})?$');

  if (!expresionValida.hasMatch(textoLimpio)) {
    return null;
  }

  final partes = textoLimpio.split('.');
  final pesos = int.tryParse(partes[0]);

  if (pesos == null) {
    return null;
  }

  final centavosTexto = partes.length > 1 ? partes[1].padRight(2, '0') : '00';

  final centavos = int.tryParse(centavosTexto);

  if (centavos == null) {
    return null;
  }

  return (pesos * 100) + centavos;
}
