import 'package:dartz/dartz.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/entities/journal_entry.dart';
import 'package:medmind/domain/repositories/journal_repository.dart';

class SearchJournalEntries {
  final JournalRepository _repository;

  const SearchJournalEntries(this._repository);

  Future<Either<Failure, List<JournalEntry>>> call(String query) {
    return _repository.searchEntries(query);
  }
}
