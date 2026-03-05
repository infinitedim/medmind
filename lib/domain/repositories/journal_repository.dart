import 'package:dartz/dartz.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/entities/journal_entry.dart';

abstract class JournalRepository {
  Future<Either<Failure, JournalEntry>> createEntry(JournalEntry entry);

  Future<Either<Failure, List<JournalEntry>>> getEntries({
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  });

  Future<Either<Failure, JournalEntry>> getEntryById(String id);

  Future<Either<Failure, JournalEntry>> updateEntry(JournalEntry entry);

  Future<Either<Failure, void>> deleteEntry(String id);

  Future<Either<Failure, List<JournalEntry>>> searchEntries(String query);

  Stream<List<JournalEntry>> watchEntries({
    DateTime? startDate,
    DateTime? endDate,
  });
}
