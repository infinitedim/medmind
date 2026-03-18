// test/unit/data/mappers/symptom_mapper_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:medmind/core/enum/enum_collection.dart';
import 'package:medmind/data/mappers/symptom_mapper.dart';
import 'package:medmind/data/models/symptom_model.dart';
import 'package:medmind/domain/entities/symptom.dart';

void main() {
  group('SymptomModelMapper', () {
    test('toDomain maps all fields correctly', () {
      final model = SymptomModel()
        ..uid = 'sym-001'
        ..name = 'Headache'
        ..category = SymptomCategory.neurological
        ..icon = '🤕'
        ..isCustom = false;

      final domain = model.toDomain();

      expect(domain.id, 'sym-001');
      expect(domain.name, 'Headache');
      expect(domain.category, SymptomCategory.neurological);
      expect(domain.icon, '🤕');
      expect(domain.isCustom, isFalse);
    });

    test('toDomain maps isCustom = true', () {
      final model = SymptomModel()
        ..uid = 'custom-sym'
        ..name = 'My Custom Symptom'
        ..category = SymptomCategory.general
        ..icon = '⚠️'
        ..isCustom = true;

      final domain = model.toDomain();

      expect(domain.isCustom, isTrue);
    });

    test('toDomain preserves all SymptomCategory values', () {
      for (final category in SymptomCategory.values) {
        final model = SymptomModel()
          ..uid = 'sym-${category.name}'
          ..name = category.name
          ..category = category
          ..icon = '●'
          ..isCustom = false;

        expect(model.toDomain().category, category);
      }
    });
  });

  group('SymptomDomainMapper', () {
    test('toModel maps all fields correctly', () {
      const symptom = Symptom(
        id: 'sym-001',
        name: 'Nausea',
        category: SymptomCategory.digestive,
        icon: '🤢',
        isCustom: false,
      );

      final model = symptom.toModel();

      expect(model.uid, 'sym-001');
      expect(model.name, 'Nausea');
      expect(model.category, SymptomCategory.digestive);
      expect(model.icon, '🤢');
      expect(model.isCustom, isFalse);
    });

    test('toModel maps isCustom = true', () {
      const symptom = Symptom(
        id: 'custom-1',
        name: 'Custom Pain',
        category: SymptomCategory.musculoskeletal,
        icon: '🦴',
        isCustom: true,
      );

      final model = symptom.toModel();

      expect(model.isCustom, isTrue);
    });
  });

  group('round-trip', () {
    test('domain → model → domain preserves all fields', () {
      const original = Symptom(
        id: 'sym-round',
        name: 'Cough',
        category: SymptomCategory.respiratory,
        icon: '💨',
        isCustom: false,
      );

      final restored = original.toModel().toDomain();

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.category, original.category);
      expect(restored.icon, original.icon);
      expect(restored.isCustom, original.isCustom);
    });

    test('model → domain → model preserves all fields', () {
      final original = SymptomModel()
        ..uid = 'sym-model-round'
        ..name = 'Fatigue'
        ..category = SymptomCategory.general
        ..icon = '😴'
        ..isCustom = false;

      final model = original.toDomain().toModel();

      expect(model.uid, original.uid);
      expect(model.name, original.name);
      expect(model.category, original.category);
      expect(model.icon, original.icon);
      expect(model.isCustom, original.isCustom);
    });
  });
}
