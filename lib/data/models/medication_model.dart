// lib/data/models/medication_model.dart
import 'package:isar/isar.dart';

part 'medication_model.g.dart';

/// Master data untuk definisi obat.
@Collection()
class MedicationModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uid; // UUID dari domain entity

  @Index()
  late String name;

  String? dosage;
  String? frequency;
}
