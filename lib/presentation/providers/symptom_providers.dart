import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medmind/domain/entities/symptom.dart';
import 'package:medmind/presentation/providers/core_providers.dart';

final allSymptomsProvider = FutureProvider<List<Symptom>>((ref) async {
  final repo = ref.watch(symptomRepositoryProvider);
  final result = await repo.getAllSymptoms();
  return result.fold((_) => [], (v) => v);
});

final selectedSymptomsProvider = StreamProvider<List<Symptom>>((ref) {
  final repo = ref.watch(symptomRepositoryProvider);
  return repo.watchSelectedSymptoms();
});

final symptomSetupNotifierProvider =
    NotifierProvider<SymptomSetupNotifier, Set<String>>(
      SymptomSetupNotifier.new,
    );

class SymptomSetupNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    _loadInitial();
    return {};
  }

  Future<void> _loadInitial() async {
    final repo = ref.read(symptomRepositoryProvider);
    final result = await repo.getSelectedSymptoms();
    result.fold((_) {}, (symptoms) {
      state = symptoms.map((s) => s.id).toSet();
    });
  }

  void toggle(String symptomId) {
    if (state.contains(symptomId)) {
      state = {...state}..remove(symptomId);
    } else {
      state = {...state, symptomId};
    }
  }

  Future<bool> save() async {
    final repo = ref.read(symptomRepositoryProvider);
    final result = await repo.setSelectedSymptoms(state.toList());
    return result.fold((_) => false, (_) => true);
  }
}
