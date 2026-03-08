// lib/data/datasources/local/symptom_local_datasource.dart
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:medmind/core/enum/enum_collection.dart';
import 'package:medmind/core/errors/exceptions.dart';
import 'package:medmind/data/models/symptom_model.dart';

/// Data source lokal untuk operasi CRUD Symptom (master data) di Isar.
@lazySingleton
class SymptomLocalDataSource {
  const SymptomLocalDataSource(this._isar);

  final Isar _isar;

  // ─── Create / Upsert ─────────────────────────────────────────────────────

  Future<void> save(SymptomModel model) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.symptomModels.put(model);
      });
    } catch (e) {
      throw DatabaseException('Gagal menyimpan symptom: $e');
    }
  }

  /// Menyimpan banyak symptom sekaligus (bulk upsert).
  Future<void> saveAll(List<SymptomModel> models) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.symptomModels.putAll(models);
      });
    } catch (e) {
      throw DatabaseException('Gagal bulk-save symptoms: $e');
    }
  }

  // ─── Read ────────────────────────────────────────────────────────────────

  Future<SymptomModel> getByUid(String uid) async {
    final result = await _isar.symptomModels
        .where()
        .uidEqualTo(uid)
        .findFirst();
    if (result == null) throw RecordNotFoundException('Symptom', uid);
    return result;
  }

  Future<List<SymptomModel>> getAll() async {
    return _isar.symptomModels.where().sortByName().findAll();
  }

  Future<List<SymptomModel>> getByCategory(SymptomCategory category) async {
    return _isar.symptomModels
        .filter()
        .categoryEqualTo(category)
        .sortByName()
        .findAll();
  }

  Future<List<SymptomModel>> getCustomSymptoms() async {
    return _isar.symptomModels
        .filter()
        .isCustomEqualTo(true)
        .sortByName()
        .findAll();
  }

  Future<List<SymptomModel>> search(String query) async {
    return _isar.symptomModels
        .filter()
        .nameContains(query, caseSensitive: false)
        .sortByName()
        .findAll();
  }

  // ─── Delete ──────────────────────────────────────────────────────────────

  Future<void> deleteByUid(String uid) async {
    final model = await getByUid(uid);
    try {
      await _isar.writeTxn(() async {
        await _isar.symptomModels.delete(model.id);
      });
    } catch (e) {
      throw DatabaseException('Gagal menghapus symptom: $e');
    }
  }

  // ─── Watch ───────────────────────────────────────────────────────────────

  Stream<List<SymptomModel>> watchAll() {
    return _isar.symptomModels.where().sortByName().watch(
      fireImmediately: true,
    );
  }

  // ─── Utility ─────────────────────────────────────────────────────────────

  Future<int> count() => _isar.symptomModels.count();
}
