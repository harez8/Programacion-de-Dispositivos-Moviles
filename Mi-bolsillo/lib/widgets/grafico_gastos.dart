import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../services/finanzas.dart';

/// Colores fijos por categoría para que el gráfico y la leyenda coincidan.
const Map<String, Color> coloresCategoria = {
  'Alimentación': Color(0xFFE76F51),
  'Transporte': Color(0xFF2A9D8F),
  'Estudio': Color(0xFF457B9D),
  'Ocio': Color(0xFFF4A261),
  'Servicios': Color(0xFF8E7DBE),
  'Salud': Color(0xFFE5989B),
  'Otros': Color(0xFF8D99AE),
};

Color colorDe(String categoria) =>
    coloresCategoria[categoria] ?? const Color(0xFF8D99AE);

/// Dona de gastos por categoría dibujada con Canvas (CustomPainter).
class GraficoGastos extends StatelessWidget {
  final Map<String, double> gastosPorCategoria;

  const GraficoGastos({super.key, required this.gastosPorCategoria});

  @override
  Widget build(BuildContext context) {
    final total = gastosPorCategoria.values.fold<double>(0, (a, b) => a + b);

    return Column(
      children: [
        SizedBox(
          height: 180,
          width: 180,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(180, 180),
                painter: _DonaPainter(gastosPorCategoria),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Gastos', style: TextStyle(fontSize: 12)),
                  Text(
                    Finanzas.formatearPesos(total),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 4,
          alignment: WrapAlignment.center,
          children: [
            for (final e in gastosPorCategoria.entries)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, size: 10, color: colorDe(e.key)),
                  const SizedBox(width: 4),
                  Text(
                    '${e.key} ${(e.value / total * 100).round()}%',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

class _DonaPainter extends CustomPainter {
  final Map<String, double> datos;

  _DonaPainter(this.datos);

  @override
  void paint(Canvas canvas, Size size) {
    const grosor = 24.0;
    final centro = Offset(size.width / 2, size.height / 2);
    final radio = math.min(size.width, size.height) / 2 - grosor / 2;
    final rect = Rect.fromCircle(center: centro, radius: radio);

    // Anillo base gris.
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = grosor
      ..color = Colors.grey.shade300;
    canvas.drawCircle(centro, radio, base);

    final total = datos.values.fold<double>(0, (a, b) => a + b);
    if (total <= 0) return;

    // Un arco por categoría, empezando arriba (-90°).
    double inicio = -math.pi / 2;
    for (final e in datos.entries) {
      final barrido = e.value / total * 2 * math.pi;
      final pincel = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = grosor
        ..color = colorDe(e.key);
      canvas.drawArc(rect, inicio, barrido, false, pincel);
      inicio += barrido;
    }
  }

  @override
  bool shouldRepaint(covariant _DonaPainter oldDelegate) =>
      oldDelegate.datos != datos;
}
