// lib/data/datasources/local/journal_local_datasource.dart
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:medmind/core/errors/exceptions.dart';
import 'package:medmind/data/models/journal_entry_model.dart';

/// Data source lokal untuk operasi CRUD JournalEntry di Isar.
@lazySingleton
class JournalLocalDataSource {
  const JournalLocalDataSource(this._isar);

  final Isar _isar;

  // ─── Create ──────────────────────────────────────────────────────────────

  /// Menyimpan [model] baru. Melempar [DatabaseException] jika gagal.
  Future<void> create(JournalEntryModel model) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.journalEntryModels.put(model);
      });
    } catch (e) {
      throw DatabaseException('Gagal menyimpan journal entry: $e');
    }
  }

  // ─── Read ────────────────────────────────────────────────────────────────

  /// Mengembalikan satu entry berdasarkan [uid] (UUID domain).
  /// Melempar [RecordNotFoundException] jika tidak ditemukan.
  Future<JournalEntryModel> getByUid(String uid) async {
    final result = await _isar.journalEntryModels
        .where()
        .uidEqualTo(uid)
        .findFirst();
    if (result == null) {
      throw RecordNotFoundException('JournalEntry', uid);
    }
    return result;
  }

  /// Mengembalikan semua entry, diurutkan dari terbaru.
  Future<List<JournalEntryModel>> getAll() async {
    return _isar.journalEntryModels.where().sortByDateDesc().findAll();
  }

  /// Mengembalikan entries dalam rentang tanggal [from]–[to] (inclusive).
  Future<List<JournalEntryModel>> getByDateRange(
    DateTime from,
    DateTime to,
  ) async {
    return _isar.journalEntryModels
        .where()
        .dateBetween(from, to)
        .sortByDateDesc()
        .findAll();
  }

  /// Mencari entries yang [freeText]-nya mengandung [query] (case-insensitive).
  Future<List<JournalEntryModel>> search(String query) async {
    // Isar 3 filter API
    return _isar.journalEntryModels
        .filter()
        .freeTextContains(query, caseSensitive: false)
        .sortByDateDesc()
        .findAll();
  }

  // ─── Update ──────────────────────────────────────────────────────────────

  /// Mengupdate entry yang sudah ada. Menggunakan [put] (upsert).
  Future<void> update(JournalEntryModel model) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.journalEntryModels.put(model);
      });
    } catch (e) {
      throw DatabaseException('Gagal mengupdate journal entry: $e');
    }
  }

  // ─── Delete ──────────────────────────────────────────────────────────────

  /// Menghapus entry berdasarkan Isar [id] internal.
  Future<void> deleteById(int id) async {
    try {
      await _isar.writeTxn(() async {
        final deleted = await _isar.journalEntryModels.delete(id);
        if (!deleted) {
          throw RecordNotFoundException('JournalEntry', id.toString());
        }
      });
    } catch (e) {
      if (e is RecordNotFoundException) rethrow;
      throw DatabaseException('Gagal menghapus journal entry: $e');
    }
  }

  /// Menghapus entry berdasarkan [uid].
  Future<void> deleteByUid(String uid) async {
    final model = await getByUid(uid);
    await deleteById(model.id);
  }

  // ─── Watch (Reactive) ────────────────────────────────────────────────────

  /// Stream yang emit setiap kali collection berubah.
  Stream<List<JournalEntryModel>> watchAll() {
    return _isar.journalEntryModels.where().sortByDateDesc().watch(
      fireImmediately: true,
    );
  }

  /// Stream untuk satu entry berdasarkan Isar [id].
  Stream<JournalEntryModel?> watchById(int id) {
    return _isar.journalEntryModels.watchObject(id, fireImmediately: true);
  }

  // ─── Utility ─────────────────────────────────────────────────────────────

  /// Mengembalikan jumlah total entry.
  Future<int> count() => _isar.journalEntryModels.count();

  /// Mengembalikan entry untuk tanggal persis [date] (tanpa waktu).
  Future<JournalEntryModel?> getByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    final results = await _isar.journalEntryModels
        .where()
        .dateBetween(startOfDay, endOfDay)
        .findAll();
    return results.isEmpty ? null : results.first;
  }
}
