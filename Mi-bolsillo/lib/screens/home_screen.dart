import 'package:flutter/material.dart';

import '../models/movimiento.dart';
import '../services/finanzas.dart';
import '../services/storage_service.dart';
import '../widgets/agregar_movimiento_sheet.dart';
import '../widgets/grafico_gastos.dart';
import '../widgets/movimiento_tile.dart';
import '../widgets/resumen_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storage = StorageService();

  List<Movimiento> _movimientos = [];
  double _meta = StorageService.metaPorDefecto;
  bool _cargando = true;
  String? _filtroCategoria; // null = mostrar todas

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final movimientos = await _storage.cargarMovimientos();
    final meta = await _storage.cargarMeta();
    if (!mounted) return;
    setState(() {
      _movimientos = movimientos;
      _meta = meta;
      _cargando = false;
    });
  }

  Future<void> _abrirFormulario() async {
    final nuevo = await showModalBottomSheet<Movimiento>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const AgregarMovimientoSheet(),
    );
    if (nuevo == null) return;

    setState(() => _movimientos = [nuevo, ..._movimientos]);
    await _storage.guardarMovimientos(_movimientos);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(nuevo.esGasto ? 'Gasto registrado ✓' : 'Ingreso registrado ✓'),
      ),
    );
  }

  Future<void> _eliminar(Movimiento m) async {
    setState(() => _movimientos = _movimientos.where((x) => x.id != m.id).toList());
    await _storage.guardarMovimientos(_movimientos);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Movimiento eliminado')),
    );
  }

  Future<void> _editarMeta() async {
    final ctrl = TextEditingController(text: _meta.round().toString());
    final formKey = GlobalKey<FormState>();

    final nueva = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Meta de ahorro'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: ctrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(prefixText: '\$ '),
            validator: Finanzas.validarMonto,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(ctx, double.parse(ctrl.text.trim().replaceAll(',', '.')));
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    ctrl.dispose();
    if (nueva == null) return;

    setState(() => _meta = nueva);
    await _storage.guardarMeta(nueva);
  }

  @override
  Widget build(BuildContext context) {
    final ingresos = Finanzas.totalPorTipo(_movimientos, TipoMovimiento.ingreso);
    final gastos = Finanzas.totalPorTipo(_movimientos, TipoMovimiento.gasto);
    final balance = ingresos - gastos;
    final gastosPorCategoria = Finanzas.gastosPorCategoria(_movimientos);
    final categorias = Finanzas.categoriasUsadas(_movimientos);

    final visibles = _filtroCategoria == null
        ? _movimientos
        : _movimientos.where((m) => m.categoria == _filtroCategoria).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Bolsillo'),
        actions: [
          IconButton(
            tooltip: 'Meta de ahorro',
            icon: const Icon(Icons.flag_outlined),
            onPressed: _editarMeta,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirFormulario,
        icon: const Icon(Icons.add),
        label: const Text('Agregar movimiento'),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              children: [
                _encabezado(),
                const SizedBox(height: 12),
                ResumenCard(balance: balance, ingresos: ingresos, gastos: gastos),
                const SizedBox(height: 8),
                _tarjetaMeta(balance),
                if (gastosPorCategoria.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text('¿En qué se va tu dinero?',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          GraficoGastos(gastosPorCategoria: gastosPorCategoria),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Text('Movimientos',
                    style: Theme.of(context).textTheme.titleMedium),
                if (categorias.isNotEmpty) _filtros(categorias),
                if (visibles.isEmpty) _estadoVacio() else ..._lista(visibles),
              ],
            ),
    );
  }

  Widget _encabezado() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'assets/images/logo.png',
            width: 64,
            height: 64,
            errorBuilder: (_, __, ___) => const Icon(Icons.account_balance_wallet, size: 64),
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'Registra tus ingresos y gastos, y mira en qué se va tu dinero cada mes.',
          ),
        ),
      ],
    );
  }

  Widget _tarjetaMeta(double balance) {
    final progreso = (balance / _meta).clamp(0.0, 1.0);
    final ahorroMes = Finanzas.balanceDelMes(_movimientos, DateTime.now());
    final meses = Finanzas.mesesParaMeta(
      meta: _meta,
      ahorrado: balance > 0 ? balance : 0,
      ahorroMensual: ahorroMes,
    );

    String mensaje;
    if (balance >= _meta) {
      mensaje = '¡Meta alcanzada! 🎉';
    } else if (meses == null) {
      mensaje = 'Este mes aún no estás ahorrando.';
    } else {
      mensaje = 'A este ritmo llegas en $meses ${meses == 1 ? 'mes' : 'meses'}.';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Meta de ahorro: ${Finanzas.formatearPesos(_meta)}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progreso, minHeight: 8),
            const SizedBox(height: 8),
            Text(mensaje),
          ],
        ),
      ),
    );
  }

  Widget _filtros(Set<String> categorias) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: const Text('Todas'),
              selected: _filtroCategoria == null,
              onSelected: (_) => setState(() => _filtroCategoria = null),
            ),
          ),
          for (final c in categorias)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(c),
                selected: _filtroCategoria == c,
                onSelected: (_) => setState(() => _filtroCategoria = c),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _lista(List<Movimiento> visibles) {
    return [
      for (final m in visibles)
        Dismissible(
          key: ValueKey(m.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            color: Colors.red.shade300,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) => _eliminar(m),
          child: MovimientoTile(movimiento: m),
        ),
    ];
  }

  Widget _estadoVacio() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(Icons.receipt_long_outlined, size: 56, color: Colors.grey),
          SizedBox(height: 8),
          Text('Aún no tienes movimientos.'),
          Text('Toca "Agregar movimiento" para registrar el primero.'),
        ],
      ),
    );
  }
}
