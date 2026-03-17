import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medmind/core/enum/enum_collection.dart';
import 'package:medmind/domain/entities/lifestyle_factor.dart';
import 'package:medmind/presentation/providers/core_providers.dart';

const _kFactorMeta = {
  'caffeine': (label: 'Kafein', type: FactorType.boolean, unit: null as String?),
  'alcohol': (label: 'Alkohol', type: FactorType.boolean, unit: null as String?),
  'meditation': (label: 'Meditasi', type: FactorType.boolean, unit: null as String?),
  'smoking': (label: 'Merokok', type: FactorType.boolean, unit: null as String?),
  'exercise': (label: 'Olahraga', type: FactorType.numeric, unit: 'menit' as String?),
  'water': (label: 'Air minum', type: FactorType.numeric, unit: 'gelas' as String?),
  'screen_time': (label: 'Screen time', type: FactorType.numeric, unit: 'jam' as String?),
  'sunlight': (label: 'Paparan sinar matahari', type: FactorType.numeric, unit: 'menit' as String?),
  'stress': (label: 'Tingkat stres', type: FactorType.scale, unit: null as String?),
  'sleep_quality': (label: 'Kualitas tidur', type: FactorType.scale, unit: null as String?),
  'diet': (label: 'Pola makan', type: FactorType.scale, unit: null as String?),
  'social': (label: 'Interaksi sosial', type: FactorType.scale, unit: null as String?),
  'sugar': (label: 'Gula', type: FactorType.scale, unit: null as String?),
  'posture': (label: 'Postur', type: FactorType.scale, unit: null as String?),
  'reading': (label: 'Membaca', type: FactorType.scale, unit: null as String?),
};

final trackedLifestyleFactorsProvider = FutureProvider<List<LifestyleFactor>>((ref) async {
  final repo = ref.watch(userPreferencesRepositoryProvider);
  final result = await repo.getTrackedLifestyleFactorIds();
  final ids = result.fold((_) => <String>[], (v) => v);
  return ids
      .where((id) => _kFactorMeta.containsKey(id))
      .map((id) {
        final meta = _kFactorMeta[id]!;
        return LifestyleFactor(id: id, name: meta.label, type: meta.type, unit: meta.unit);
      })
      .toList();
});

final onboardingCompleteProvider = FutureProvider<bool>((ref) async {
  final repo = ref.watch(userPreferencesRepositoryProvider);
  final result = await repo.isOnboardingComplete();
  return result.fold((_) => false, (v) => v);
});

final biometricEnabledProvider = FutureProvider<bool>((ref) async {
  final repo = ref.watch(userPreferencesRepositoryProvider);
  final result = await repo.isBiometricEnabled();
  return result.fold((_) => false, (v) => v);
});

final reminderTimeProvider = FutureProvider<String?>((ref) async {
  final repo = ref.watch(userPreferencesRepositoryProvider);
  final result = await repo.getReminderTime();
  return result.fold((_) => null, (v) => v);
});

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    _load();
    return ThemeMode.dark;
  }

  Future<void> _load() async {
    final repo = ref.read(userPreferencesRepositoryProvider);
    final result = await repo.getThemeMode();
    result.fold((_) {}, (mode) {
      state = switch (mode) {
        'light' => ThemeMode.light,
        'system' => ThemeMode.system,
        _ => ThemeMode.dark,
      };
    });
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    final modeString = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.system => 'system',
      _ => 'dark',
    };
    final repo = ref.read(userPreferencesRepositoryProvider);
    await repo.setThemeMode(modeString);
  }
}
