import 'package:flutter/material.dart';

import '../models/movimiento.dart';
import '../services/finanzas.dart';

/// Formulario con validación. Cambia al elegir tipo, por eso es StatefulWidget.
class AgregarMovimientoSheet extends StatefulWidget {
  const AgregarMovimientoSheet({super.key});

  @override
  State<AgregarMovimientoSheet> createState() => _AgregarMovimientoSheetState();
}

class _AgregarMovimientoSheetState extends State<AgregarMovimientoSheet> {
  final _formKey = GlobalKey<FormState>();
  final _descripcionCtrl = TextEditingController();
  final _montoCtrl = TextEditingController();
  final _notaCtrl = TextEditingController();

  TipoMovimiento _tipo = TipoMovimiento.gasto;
  String _categoria = categoriasGasto.first;

  List<String> get _categorias =>
      _tipo == TipoMovimiento.gasto ? categoriasGasto : categoriasIngreso;

  @override
  void dispose() {
    _descripcionCtrl.dispose();
    _montoCtrl.dispose();
    _notaCtrl.dispose();
    super.dispose();
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;

    final nota = _notaCtrl.text.trim();
    final movimiento = Movimiento(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      descripcion: _descripcionCtrl.text.trim(),
      monto: double.parse(_montoCtrl.text.trim().replaceAll(',', '.')),
      tipo: _tipo,
      categoria: _categoria,
      fecha: DateTime.now(),
      nota: nota.isEmpty ? null : nota,
    );
    Navigator.of(context).pop(movimiento);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Nuevo movimiento',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              SegmentedButton<TipoMovimiento>(
                segments: const [
                  ButtonSegment(
                    value: TipoMovimiento.gasto,
                    label: Text('Gasto'),
                    icon: Icon(Icons.arrow_upward),
                  ),
                  ButtonSegment(
                    value: TipoMovimiento.ingreso,
                    label: Text('Ingreso'),
                    icon: Icon(Icons.arrow_downward),
                  ),
                ],
                selected: {_tipo},
                onSelectionChanged: (seleccion) {
                  setState(() {
                    _tipo = seleccion.first;
                    _categoria = _categorias.first;
                  });
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descripcionCtrl,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().length < 3) {
                    return 'Escribe al menos 3 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _montoCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Monto (COP)',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(),
                ),
                validator: Finanzas.validarMonto,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                // ignore: deprecated_member_use
                value: _categoria,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final c in _categorias)
                    DropdownMenuItem(value: c, child: Text(c)),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _categoria = v);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notaCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nota (opcional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _guardar,
                icon: const Icon(Icons.check),
                label: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
