// test/unit/domain/usecases/export/export_to_csv_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/usecases/export/export_to_csv.dart';
import 'package:medmind/domain/usecases/export/export_to_pdf.dart';

import '../../../../helpers/mock_repositories.dart';
import '../../../../helpers/test_fixtures.dart';

void main() {
  late MockCsvExportDataSource dataSource;
  late ExportToCsv useCase;

  setUp(() {
    registerFallbackValues();
    dataSource = MockCsvExportDataSource();
    useCase = ExportToCsv(dataSource);
  });

  group('ExportToCsv', () {
    test('returns ValidationFailure when entries list is empty', () async {
      final params = ExportParams(entries: const []);
      final result = await useCase(params);

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<ValidationFailure>()),
        (_) => fail('Expected Left'),
      );
      verifyZeroInteractions(dataSource);
    });

    test('delegates to dataSource when entries not empty', () async {
      final entry = makeFullEntry();
      final params = ExportParams(entries: [entry]);
      when(() => dataSource.generate(any()))
          .thenAnswer((_) async => const Right('/data/export.csv'));

      final result = await useCase(params);

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('Expected Right'), (path) => expect(path, '/data/export.csv'));
      verify(() => dataSource.generate(any())).called(1);
    });

    test('propagates ExportFailure from dataSource', () async {
      final params = ExportParams(entries: [makeMinimalEntry()]);
      when(() => dataSource.generate(any()))
          .thenAnswer((_) async => const Left(ExportFailure('disk full')));

      final result = await useCase(params);

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) {
          expect(f, isA<ExportFailure>());
          expect(f.message, 'disk full');
        },
        (_) => fail('Expected Left'),
      );
    });

    test('forwards date range params to dataSource unchanged', () async {
      final start = DateTime(2026, 1, 1);
      final end = DateTime(2026, 3, 1);
      final params = ExportParams(
        entries: [makeMinimalEntry()],
        startDate: start,
        endDate: end,
      );
      ExportParams? captured;
      when(() => dataSource.generate(any())).thenAnswer((inv) async {
        captured = inv.positionalArguments.first as ExportParams;
        return const Right('/out.csv');
      });

      await useCase(params);

      expect(captured?.startDate, start);
      expect(captured?.endDate, end);
    });
  });
}
