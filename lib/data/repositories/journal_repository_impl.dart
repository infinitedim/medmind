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
  const JournalRepositoryImpl(this._dataSource);

  final JournalLocalDataSource _dataSource;

  @override
  Future<Either<Failure, JournalEntry>> createEntry(JournalEntry entry) async {
    try {
      await _dataSource.create(entry.toModel());
      return Right(entry);
    } on AppException catch (e) {
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
      final models = (startDate != null && endDate != null)
          ? await _dataSource.getByDateRange(startDate, endDate)
          : await _dataSource.getAll();

      final start = (offset ?? 0).clamp(0, models.length);
      final end = limit != null
          ? (start + limit).clamp(start, models.length)
          : models.length;

      return Right(
        models.sublist(start, end).map((m) => m.toDomain()).toList(),
      );
    } on AppException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, JournalEntry>> getEntryById(String id) async {
    try {
      final model = await _dataSource.getByUid(id);
      return Right(model.toDomain());
    } on RecordNotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on AppException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, JournalEntry>> updateEntry(JournalEntry entry) async {
    try {
      final existing = await _dataSource.getByUid(entry.id);
      final model = entry.toModel()..id = existing.id;
      await _dataSource.update(model);
      return Right(entry);
    } on RecordNotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on AppException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEntry(String id) async {
    try {
      await _dataSource.deleteByUid(id);
      return const Right(null);
    } on RecordNotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on AppException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<JournalEntry>>> searchEntries(
    String query,
  ) async {
    try {
      final models = await _dataSource.search(query);
      return Right(models.map((m) => m.toDomain()).toList());
    } on AppException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Stream<List<JournalEntry>> watchEntries({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _dataSource.watchAll().map((models) {
      var filtered = models;
      if (startDate != null) {
        filtered = filtered.where((m) => !m.date.isBefore(startDate)).toList();
      }
      if (endDate != null) {
        filtered = filtered.where((m) => !m.date.isAfter(endDate)).toList();
      }
      return filtered.map((m) => m.toDomain()).toList();
    });
  }
}
