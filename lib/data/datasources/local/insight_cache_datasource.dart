// lib/data/datasources/local/insight_cache_datasource.dart
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:medmind/core/enum/enum_collection.dart';
import 'package:medmind/core/errors/exceptions.dart';
import 'package:medmind/data/models/insight_model.dart';

/// Cache lokal untuk hasil Insight Engine.
///
/// Insights di-generate oleh [InsightEngine] (domain service) dan di-cache
/// di sini agar tidak perlu di-recompute setiap launch.
@lazySingleton
class InsightCacheDataSource {
  const InsightCacheDataSource(this._isar);

  final Isar _isar;

  // ─── Write ───────────────────────────────────────────────────────────────

  Future<void> save(InsightModel model) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.insightModels.put(model);
      });
    } catch (e) {
      throw CacheException('Gagal menyimpan insight ke cache: $e');
    }
  }

  Future<void> saveAll(List<InsightModel> models) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.insightModels.putAll(models);
      });
    } catch (e) {
      throw CacheException('Gagal bulk-save insights: $e');
    }
  }

  // ─── Read ────────────────────────────────────────────────────────────────

  Future<InsightModel> getByUid(String uid) async {
    final result = await _isar.insightModels
        .where()
        .uidEqualTo(uid)
        .findFirst();
    if (result == null) throw RecordNotFoundException('Insight', uid);
    return result;
  }

  Future<List<InsightModel>> getAll() async {
    return _isar.insightModels.where().sortByGeneratedAtDesc().findAll();
  }

  Future<List<InsightModel>> getUnread() async {
    return _isar.insightModels
        .filter()
        .isReadEqualTo(false)
        .sortByGeneratedAtDesc()
        .findAll();
  }

  Future<List<InsightModel>> getSaved() async {
    return _isar.insightModels
        .filter()
        .isSavedEqualTo(true)
        .sortByGeneratedAtDesc()
        .findAll();
  }

  Future<List<InsightModel>> getByType(InsightType type) async {
    return _isar.insightModels
        .filter()
        .typeEqualTo(type)
        .sortByGeneratedAtDesc()
        .findAll();
  }

  // ─── Update (partial) ────────────────────────────────────────────────────

  Future<void> markAsRead(String uid) async {
    final model = await getByUid(uid);
    model.isRead = true;
    await save(model);
  }

  Future<void> toggleSaved(String uid) async {
    final model = await getByUid(uid);
    model.isSaved = !model.isSaved;
    await save(model);
  }

  // ─── Delete ──────────────────────────────────────────────────────────────

  Future<void> deleteByUid(String uid) async {
    final model = await getByUid(uid);
    try {
      await _isar.writeTxn(() async {
        await _isar.insightModels.delete(model.id);
      });
    } catch (e) {
      throw CacheException('Gagal menghapus insight dari cache: $e');
    }
  }

  /// Menghapus semua insights yang sudah lebih dari [days] hari.
  Future<void> evictOlderThan(int days) async {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    try {
      await _isar.writeTxn(() async {
        await _isar.insightModels
            .filter()
            .generatedAtLessThan(cutoff)
            .deleteAll();
      });
    } catch (e) {
      throw CacheException('Gagal evict old insights: $e');
    }
  }

  // ─── Watch ───────────────────────────────────────────────────────────────

  Stream<List<InsightModel>> watchAll() {
    return _isar.insightModels.where().sortByGeneratedAtDesc().watch(
      fireImmediately: true,
    );
  }

  // ─── Utility ─────────────────────────────────────────────────────────────

  Future<int> countUnread() async {
    return _isar.insightModels.filter().isReadEqualTo(false).count();
  }
}
