import 'package:flutter/material.dart';

import '../services/finanzas.dart';

/// Contenido fijo que solo recibe datos: StatelessWidget.
class ResumenCard extends StatelessWidget {
  final double balance;
  final double ingresos;
  final double gastos;

  const ResumenCard({
    super.key,
    required this.balance,
    required this.ingresos,
    required this.gastos,
  });

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    return Card(
      color: colores.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Balance total'),
            Text(
              Finanzas.formatearPesos(balance),
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _dato(Icons.arrow_downward, 'Ingresos', ingresos,
                    Colors.green.shade700),
                const SizedBox(width: 24),
                _dato(Icons.arrow_upward, 'Gastos', gastos,
                    Colors.red.shade700),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dato(IconData icono, String titulo, double valor, Color color) {
    return Row(
      children: [
        Icon(icono, color: color, size: 20),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: const TextStyle(fontSize: 12)),
            Text(Finanzas.formatearPesos(valor),
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}
