// test/unit/domain/usecases/journal/search_journal_entries_test.dart

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/entities/journal_entry.dart';
import 'package:medmind/domain/usecases/journal/search_journal_entries.dart';

import '../../../../helpers/mock_repositories.dart';
import '../../../../helpers/test_fixtures.dart';

void main() {
  late SearchJournalEntries usecase;
  late MockJournalRepository mockRepository;

  setUpAll(registerFallbackValues);

  setUp(() {
    mockRepository = MockJournalRepository();
    usecase = SearchJournalEntries(mockRepository);
  });

  final tEntries = makeEntryList(count: 2);

  group('SearchJournalEntries', () {
    test('mengembalikan entries yang cocok dengan query', () async {
      when(
        () => mockRepository.searchEntries(any()),
      ).thenAnswer((_) async => Right(tEntries));

      final result = await usecase('headache');

      expect(result, Right(tEntries));
      verify(() => mockRepository.searchEntries('headache')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('mengembalikan list kosong jika tidak ada hasil', () async {
      when(
        () => mockRepository.searchEntries(any()),
      ).thenAnswer((_) async => const Right([]));

      final result = await usecase('nonexistent query');

      expect(result, const Right(<JournalEntry>[]));
    });

    test('mengembalikan DatabaseFailure ketika pencarian gagal', () async {
      const failure = DatabaseFailure('Pencarian gagal');
      when(
        () => mockRepository.searchEntries(any()),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase('headache');

      expect(result, const Left(failure));
    });

    test('meneruskan query string yang tepat ke repository', () async {
      const query = 'migraine after coffee';
      when(
        () => mockRepository.searchEntries(query),
      ).thenAnswer((_) async => const Right([]));

      await usecase(query);

      verify(() => mockRepository.searchEntries(query)).called(1);
    });

    test('mendukung query kosong', () async {
      when(
        () => mockRepository.searchEntries(any()),
      ).thenAnswer((_) async => Right(tEntries));

      final result = await usecase('');

      expect(result.isRight(), true);
      verify(() => mockRepository.searchEntries('')).called(1);
    });
  });
}
