// test/unit/domain/usecases/journal/delete_journal_entry_test.dart

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/usecases/journal/delete_journal_entry.dart';

import '../../../../helpers/mock_repositories.dart';
import '../../../../helpers/test_fixtures.dart';

void main() {
  late DeleteJournalEntry usecase;
  late MockJournalRepository mockRepository;

  setUpAll(registerFallbackValues);

  setUp(() {
    mockRepository = MockJournalRepository();
    usecase = DeleteJournalEntry(mockRepository);
  });

  group('DeleteJournalEntry', () {
    test('mengembalikan Right(void) ketika entry berhasil dihapus', () async {
      when(
        () => mockRepository.deleteEntry(any()),
      ).thenAnswer((_) async => const Right(null));

      final result = await usecase(kTestEntryId);

      expect(result.isRight(), true);
      verify(() => mockRepository.deleteEntry(kTestEntryId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('mengembalikan NotFoundFailure jika entry tidak ditemukan', () async {
      const failure = NotFoundFailure('Entry tidak ditemukan');
      when(
        () => mockRepository.deleteEntry(any()),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase(kTestEntryId);

      expect(result, const Left(failure));
    });

    test('mengembalikan DatabaseFailure ketika repository gagal', () async {
      const failure = DatabaseFailure('Operasi delete gagal');
      when(
        () => mockRepository.deleteEntry(any()),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase(kTestEntryId);

      expect(result, const Left(failure));
    });

    test('meneruskan id yang benar ke repository', () async {
      const customId = 'custom-id-999';
      when(
        () => mockRepository.deleteEntry(customId),
      ).thenAnswer((_) async => const Right(null));

      await usecase(customId);

      verify(() => mockRepository.deleteEntry(customId)).called(1);
    });
  });
}
