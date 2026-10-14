import 'package:flutter/material.dart';

import '../models/movimiento.dart';
import '../services/finanzas.dart';
import 'grafico_gastos.dart';

class MovimientoTile extends StatelessWidget {
  final Movimiento movimiento;

  const MovimientoTile({super.key, required this.movimiento});

  @override
  Widget build(BuildContext context) {
    final esGasto = movimiento.esGasto;
    final f = movimiento.fecha;
    final fecha = '${f.day.toString().padLeft(2, '0')}/'
        '${f.month.toString().padLeft(2, '0')}/${f.year}';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorDe(movimiento.categoria).withOpacity(0.2),
          child: Icon(
            esGasto ? Icons.shopping_bag_outlined : Icons.savings_outlined,
            color: colorDe(movimiento.categoria),
          ),
        ),
        title: Text(movimiento.descripcion),
        subtitle: Text('${movimiento.categoria} · $fecha'),
        trailing: Text(
          Finanzas.formatearPesos(movimiento.valorConSigno()),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: esGasto ? Colors.red.shade700 : Colors.green.shade700,
          ),
        ),
      ),
    );
  }
}
