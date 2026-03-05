import 'package:dartz/dartz.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/entities/journal_entry.dart';
import 'package:medmind/domain/repositories/journal_repository.dart';

class GetJournalEntriesParams {
  final DateTime? startDate;
  final DateTime? endDate;
  final int? limit;
  final int? offset;

  const GetJournalEntriesParams({
    this.startDate,
    this.endDate,
    this.limit,
    this.offset,
  });
}

class GetJournalEntries {
  final JournalRepository _repository;

  const GetJournalEntries(this._repository);

  Future<Either<Failure, List<JournalEntry>>> call(
    GetJournalEntriesParams params,
  ) {
    return _repository.getEntries(
      startDate: params.startDate,
      endDate: params.endDate,
      limit: params.limit,
      offset: params.offset,
    );
  }

  Stream<List<JournalEntry>> watch({DateTime? startDate, DateTime? endDate}) {
    return _repository.watchEntries(startDate: startDate, endDate: endDate);
  }
}
