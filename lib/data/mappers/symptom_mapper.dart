// lib/data/mappers/symptom_mapper.dart
import 'package:medmind/data/models/symptom_model.dart';
import 'package:medmind/domain/entities/symptom.dart';

/// Konversi antara [Symptom] (domain) dan [SymptomModel] (data/Isar).
/// Model fields sudah menggunakan domain enum [SymptomCategory] langsung.
extension SymptomModelMapper on SymptomModel {
  Symptom toDomain() {
    return Symptom(
      id: uid,
      name: name,
      category: category,
      icon: icon,
      isCustom: isCustom,
    );
  }
}

extension SymptomDomainMapper on Symptom {
  SymptomModel toModel() {
    return SymptomModel()
      ..uid = id
      ..name = name
      ..category = category
      ..icon = icon
      ..isCustom = isCustom;
  }
}
