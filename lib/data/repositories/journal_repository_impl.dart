import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:medmind/core/errors/exceptions.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/data/datasources/local/journal_local_datasource.dart';
import 'package:medmind/data/mappers/journal_entry_mapper.dart';
import 'package:medmind/domain/entities/journal_entry.dart';
import 'package:medmind/domain/repositories/journal_repository.dart';

@LazySingleton(as: JournalRepository)
class JournalRepositoryImpl implements JournalRepository {
  const JournalRepositoryImpl(this._datasource);

  final JournalLocalDataSource _datasource;

  @override
  Future<Either<Failure, JournalEntry>> createEntry(JournalEntry entry) async {
    try {
      final model = entry.toModel();
      await _datasource.create(model);
      return Right(entry);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<JournalEntry>>> getEntries({
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  }) async {
    try {
      List<JournalEntry> entries;
      if (startDate != null && endDate != null) {
        final models = await _datasource.getByDateRange(startDate, endDate);
        entries = models.map((m) => m.toDomain()).toList();
      } else {
        final models = await _datasource.getAll();
        entries = models.map((m) => m.toDomain()).toList();
      }
      if (limit != null || offset != null) {
        final start = offset ?? 0;
        final end = limit != null ? start + limit : entries.length;
        entries = entries.sublist(
          start.clamp(0, entries.length),
          end.clamp(0, entries.length),
        );
      }
      return Right(entries);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, JournalEntry>> getEntryById(String id) async {
    try {
      final model = await _datasource.getByUid(id);
      return Right(model.toDomain());
    } on RecordNotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, JournalEntry>> updateEntry(JournalEntry entry) async {
    try {
      final existing = await _datasource.getByUid(entry.id);
      final model = entry.toModel()..id = existing.id;
      await _datasource.update(model);
      return Right(entry);
    } on RecordNotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEntry(String id) async {
    try {
      await _datasource.deleteByUid(id);
      return const Right(null);
    } on RecordNotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<JournalEntry>>> searchEntries(String query) async {
    try {
      final models = await _datasource.search(query);
      return Right(models.map((m) => m.toDomain()).toList());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Stream<List<JournalEntry>> watchEntries({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _datasource.watchAll().map((models) {
      var entries = models.map((m) => m.toDomain()).toList();
      if (startDate != null) {
        entries = entries.where((e) => !e.date.isBefore(startDate)).toList();
      }
      if (endDate != null) {
        entries = entries.where((e) => !e.date.isAfter(endDate)).toList();
      }
      return entries;
    });
  }
}
