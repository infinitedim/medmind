// test/unit/domain/usecases/export/export_to_pdf_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/usecases/export/export_to_pdf.dart';

import '../../../../helpers/mock_repositories.dart';
import '../../../../helpers/test_fixtures.dart';

void main() {
  late MockPdfExportDataSource dataSource;
  late ExportToPdf useCase;

  setUp(() {
    registerFallbackValues();
    dataSource = MockPdfExportDataSource();
    useCase = ExportToPdf(dataSource);
  });

  group('ExportToPdf', () {
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
      final params = ExportParams(entries: [makeMinimalEntry()]);
      when(() => dataSource.generate(any()))
          .thenAnswer((_) async => const Right('/data/export.pdf'));

      final result = await useCase(params);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (path) => expect(path, '/data/export.pdf'),
      );
      verify(() => dataSource.generate(any())).called(1);
    });

    test('propagates ExportFailure from dataSource', () async {
      final params = ExportParams(entries: [makeFullEntry()]);
      when(() => dataSource.generate(any()))
          .thenAnswer((_) async => const Left(ExportFailure('render failed')));

      final result = await useCase(params);

      result.fold(
        (f) {
          expect(f, isA<ExportFailure>());
          expect(f.message, 'render failed');
        },
        (_) => fail('Expected Left'),
      );
    });

    test('dataSource is called exactly once per invocation', () async {
      final params = ExportParams(entries: [makeMinimalEntry(), makeFullEntry()]);
      when(() => dataSource.generate(any()))
          .thenAnswer((_) async => const Right('/out.pdf'));

      await useCase(params);
      await useCase(params);

      verify(() => dataSource.generate(any())).called(2);
    });
  });
}
