// test/unit/domain/usecases/journal/get_journal_entries_test.dart

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/entities/journal_entry.dart';
import 'package:medmind/domain/usecases/journal/get_journal_entries.dart';

import '../../../../helpers/mock_repositories.dart';
import '../../../../helpers/test_fixtures.dart';

void main() {
  late GetJournalEntries usecase;
  late MockJournalRepository mockRepository;

  setUpAll(registerFallbackValues);

  setUp(() {
    mockRepository = MockJournalRepository();
    usecase = GetJournalEntries(mockRepository);
  });

  final tEntries = makeEntryList(count: 3);
  const tParams = GetJournalEntriesParams();

  group('GetJournalEntries', () {
    test('mengembalikan list entries ketika repository berhasil', () async {
      when(
        () => mockRepository.getEntries(
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        ),
      ).thenAnswer((_) async => Right(tEntries));

      final result = await usecase(tParams);

      expect(result, Right(tEntries));
    });

    test('mengembalikan list kosong jika tidak ada entries', () async {
      when(
        () => mockRepository.getEntries(
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        ),
      ).thenAnswer((_) async => const Right([]));

      final result = await usecase(tParams);

      expect(result, const Right(<JournalEntry>[]));
    });

    test(
      'meneruskan parameter date range ke repository dengan benar',
      () async {
        final start = DateTime(2026, 1, 1);
        final end = DateTime(2026, 3, 8);
        final params = GetJournalEntriesParams(
          startDate: start,
          endDate: end,
          limit: 10,
          offset: 0,
        );

        when(
          () => mockRepository.getEntries(
            startDate: start,
            endDate: end,
            limit: 10,
            offset: 0,
          ),
        ).thenAnswer((_) async => Right(tEntries));

        await usecase(params);

        verify(
          () => mockRepository.getEntries(
            startDate: start,
            endDate: end,
            limit: 10,
            offset: 0,
          ),
        ).called(1);
      },
    );

    test('mengembalikan DatabaseFailure ketika repository gagal', () async {
      const failure = DatabaseFailure('Gagal mengambil entries');
      when(
        () => mockRepository.getEntries(
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase(tParams);

      expect(result, const Left(failure));
    });
  });
}
