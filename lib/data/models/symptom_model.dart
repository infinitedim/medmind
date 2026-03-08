// lib/data/models/symptom_model.dart
import 'package:isar/isar.dart';
import 'package:medmind/core/enum/enum_collection.dart';

part 'symptom_model.g.dart';

@Collection()
class SymptomModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uid; // UUID dari domain entity

  @Index()
  late String name;

  @Enumerated(EnumType.name)
  late SymptomCategory category;

  late String icon;

  late bool isCustom;
}
