// test/unit/domain/usecases/journal/update_journal_entry_test.dart

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/usecases/journal/update_journal_entry.dart';

import '../../../../helpers/mock_repositories.dart';
import '../../../../helpers/test_fixtures.dart';

void main() {
  late UpdateJournalEntry usecase;
  late MockJournalRepository mockRepository;

  setUpAll(registerFallbackValues);

  setUp(() {
    mockRepository = MockJournalRepository();
    usecase = UpdateJournalEntry(mockRepository);
  });

  final tEntry = makeMinimalEntry();
  final tUpdatedEntry = makeFullEntry();

  group('UpdateJournalEntry', () {
    test('mengembalikan JournalEntry yang telah diperbarui', () async {
      when(
        () => mockRepository.updateEntry(any()),
      ).thenAnswer((_) async => Right(tUpdatedEntry));

      final result = await usecase(tUpdatedEntry);

      expect(result, Right(tUpdatedEntry));
      verify(() => mockRepository.updateEntry(tUpdatedEntry)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('mengembalikan DatabaseFailure ketika update gagal', () async {
      const failure = DatabaseFailure('Gagal memperbarui entry');
      when(
        () => mockRepository.updateEntry(any()),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase(tEntry);

      expect(result, const Left(failure));
    });

    test('mengembalikan NotFoundFailure jika entry tidak ditemukan', () async {
      const failure = NotFoundFailure('Entry tidak ditemukan');
      when(
        () => mockRepository.updateEntry(any()),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase(tEntry);

      expect(result, const Left(failure));
    });

    test('meneruskan entry lengkap ke repository tanpa modifikasi', () async {
      when(
        () => mockRepository.updateEntry(any()),
      ).thenAnswer((_) async => Right(tUpdatedEntry));

      await usecase(tUpdatedEntry);

      final captured = verify(
        () => mockRepository.updateEntry(captureAny()),
      ).captured;
      expect(captured.single, equals(tUpdatedEntry));
    });
  });
}
