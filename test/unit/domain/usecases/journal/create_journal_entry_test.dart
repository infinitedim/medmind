// test/unit/domain/usecases/journal/create_journal_entry_test.dart

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/usecases/journal/create_journal_entry.dart';

import '../../../../helpers/mock_repositories.dart';
import '../../../../helpers/test_fixtures.dart';

void main() {
  late CreateJournalEntry usecase;
  late MockJournalRepository mockRepository;

  setUpAll(registerFallbackValues);

  setUp(() {
    mockRepository = MockJournalRepository();
    usecase = CreateJournalEntry(mockRepository);
  });

  final tEntry = makeMinimalEntry();

  group('CreateJournalEntry', () {
    test('mengembalikan JournalEntry ketika repository berhasil', () async {
      when(
        () => mockRepository.createEntry(any()),
      ).thenAnswer((_) async => Right(tEntry));

      final result = await usecase(tEntry);

      expect(result, Right(tEntry));
      verify(() => mockRepository.createEntry(tEntry)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('mengembalikan DatabaseFailure ketika repository gagal', () async {
      const failure = DatabaseFailure('Gagal menyimpan entry');
      when(
        () => mockRepository.createEntry(any()),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase(tEntry);

      expect(result, const Left(failure));
      verify(() => mockRepository.createEntry(tEntry)).called(1);
    });

    test('memanggil repository tepat 1 kali', () async {
      when(
        () => mockRepository.createEntry(any()),
      ).thenAnswer((_) async => Right(tEntry));

      await usecase(tEntry);

      verify(() => mockRepository.createEntry(tEntry)).called(1);
    });

    test('meneruskan entry yang sama ke repository tanpa modifikasi', () async {
      final fullEntry = makeFullEntry();
      when(
        () => mockRepository.createEntry(any()),
      ).thenAnswer((_) async => Right(fullEntry));

      await usecase(fullEntry);

      final captured = verify(
        () => mockRepository.createEntry(captureAny()),
      ).captured;
      expect(captured.single, equals(fullEntry));
    });
  });
}
