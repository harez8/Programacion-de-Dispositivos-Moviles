import '../models/movimiento.dart';

/// Funciones de cálculo y validación (lógica separada de la interfaz).
class Finanzas {
  /// Suma los montos de un tipo (recorre la lista con for + if).
  static double totalPorTipo(List<Movimiento> lista, TipoMovimiento tipo) {
    double total = 0;
    for (final m in lista) {
      if (m.tipo == tipo) total += m.monto;
    }
    return total;
  }

  /// Map: categoría -> total gastado.
  static Map<String, double> gastosPorCategoria(List<Movimiento> lista) {
    final Map<String, double> resumen = {};
    for (final m in lista) {
      if (m.esGasto) {
        resumen[m.categoria] = (resumen[m.categoria] ?? 0) + m.monto;
      }
    }
    return resumen;
  }

  /// Set: categorías usadas, sin repetidos.
  static Set<String> categoriasUsadas(List<Movimiento> lista) {
    return {for (final m in lista) m.categoria};
  }

  /// Balance (ingresos - gastos) solo del mes actual.
  static double balanceDelMes(List<Movimiento> lista, DateTime hoy) {
    double balance = 0;
    for (final m in lista) {
      if (m.fecha.year == hoy.year && m.fecha.month == hoy.month) {
        balance += m.valorConSigno();
      }
    }
    return balance;
  }

  /// Valida el monto escrito por el usuario. Devuelve null si es válido.
  static String? validarMonto(String? texto) {
    if (texto == null || texto.trim().isEmpty) return 'Escribe un monto';
    final valor = double.tryParse(texto.trim().replaceAll(',', '.'));
    if (valor == null) return 'Ingresa solo números';
    if (valor <= 0) return 'El monto debe ser mayor a 0';
    return null;
  }

  /// Cuántos meses faltan para llegar a la meta ahorrando [ahorroMensual]
  /// cada mes. Usa un while finito (máximo 600 meses = 50 años).
  /// Devuelve null si no se está ahorrando.
  static int? mesesParaMeta({
    required double meta,
    required double ahorrado,
    required double ahorroMensual,
  }) {
    if (ahorroMensual <= 0) return null;
    double acumulado = ahorrado;
    int meses = 0;
    while (acumulado < meta && meses < 600) {
      acumulado += ahorroMensual;
      meses++;
    }
    return meses;
  }

  /// Formato de pesos colombianos: 1234567 -> $1.234.567
  static String formatearPesos(double valor) {
    final entero = valor.round().abs().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < entero.length; i++) {
      final restantes = entero.length - i;
      buffer.write(entero[i]);
      if (restantes > 1 && restantes % 3 == 1) buffer.write('.');
    }
    final signo = valor < 0 ? '-' : '';
    return '$signo\$$buffer';
  }
}
