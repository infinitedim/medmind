import 'package:dartz/dartz.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/entities/journal_entry.dart';
import 'package:medmind/domain/repositories/journal_repository.dart';

class CreateJournalEntry {
  final JournalRepository _repository;

  CreateJournalEntry(this._repository);

  Future<Either<Failure, JournalEntry>> call(JournalEntry entry) {
    // Validasi bisnis bisa ditaruh di sini
    // contoh: pastikan date tidak di masa depan
    return _repository.createEntry(entry);
  }
}
