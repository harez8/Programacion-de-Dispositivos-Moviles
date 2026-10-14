import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/movimiento.dart';

/// Guarda y lee los datos en el dispositivo con SharedPreferences.
class StorageService {
  static const _claveMovimientos = 'movimientos';
  static const _claveMeta = 'meta_ahorro';
  static const double metaPorDefecto = 1000000;

  Future<List<Movimiento>> cargarMovimientos() async {
    final prefs = await SharedPreferences.getInstance();
    final texto = prefs.getString(_claveMovimientos);
    if (texto == null) return [];
    final lista = jsonDecode(texto) as List<dynamic>;
    return lista
        .map((e) => Movimiento.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> guardarMovimientos(List<Movimiento> movimientos) async {
    final prefs = await SharedPreferences.getInstance();
    final texto = jsonEncode(movimientos.map((m) => m.toJson()).toList());
    await prefs.setString(_claveMovimientos, texto);
  }

  Future<double> cargarMeta() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_claveMeta) ?? metaPorDefecto;
  }

  Future<void> guardarMeta(double meta) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_claveMeta, meta);
  }
}
