import 'package:dartz/dartz.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/repositories/journal_repository.dart';

class DeleteJournalEntry {
  final JournalRepository _repository;

  const DeleteJournalEntry(this._repository);

  Future<Either<Failure, void>> call(String id) {
    return _repository.deleteEntry(id);
  }
}
