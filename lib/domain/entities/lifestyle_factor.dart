import 'package:medmind/core/enum/enum_collection.dart';

class LifestyleFactor {
  final String id;
  final String name;
  final FactorType type;
  final String? unit;

  LifestyleFactor({
    required this.id,
    required this.name,
    required this.type,
    this.unit,
  });
}

class LifestyleFactorLog {
  final String factorId;
  final bool? boolValue; // untuk tipe boolean: "Consumed caffeine?"
  final double? numericValue; // untuk tipe numeric: "3 cups"
  final int? scaleValue; // untuk tipe scale: 1-10

  LifestyleFactorLog({
    required this.factorId,
    this.boolValue,
    this.numericValue,
    this.scaleValue,
  });
}
