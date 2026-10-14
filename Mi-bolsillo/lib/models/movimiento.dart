/// Tipos posibles de un movimiento de dinero.
enum TipoMovimiento { ingreso, gasto }

/// Categorías disponibles (listas inmutables con const).
const List<String> categoriasGasto = [
  'Alimentación',
  'Transporte',
  'Estudio',
  'Ocio',
  'Servicios',
  'Salud',
  'Otros',
];

const List<String> categoriasIngreso = [
  'Mesada',
  'Salario',
  'Extra',
  'Otros',
];

/// Modelo central de la app: un ingreso o un gasto.
class Movimiento {
  final String id;
  final String descripcion;
  final double monto; // siempre positivo; el tipo define el signo
  final TipoMovimiento tipo;
  final String categoria;
  final DateTime fecha;
  final String? nota; // nullable: es opcional

  const Movimiento({
    required this.id,
    required this.descripcion,
    required this.monto,
    required this.tipo,
    required this.categoria,
    required this.fecha,
    this.nota,
  });

  bool get esGasto => tipo == TipoMovimiento.gasto;

  /// Valor con signo: negativo si es gasto, positivo si es ingreso.
  double valorConSigno() => esGasto ? -monto : monto;

  Map<String, dynamic> toJson() => {
        'id': id,
        'descripcion': descripcion,
        'monto': monto,
        'tipo': tipo.name,
        'categoria': categoria,
        'fecha': fecha.toIso8601String(),
        'nota': nota,
      };

  factory Movimiento.fromJson(Map<String, dynamic> json) => Movimiento(
        id: json['id'] as String,
        descripcion: json['descripcion'] as String,
        monto: (json['monto'] as num).toDouble(),
        tipo: TipoMovimiento.values.byName(json['tipo'] as String),
        categoria: json['categoria'] as String,
        fecha: DateTime.parse(json['fecha'] as String),
        nota: json['nota'] as String?,
      );
}
