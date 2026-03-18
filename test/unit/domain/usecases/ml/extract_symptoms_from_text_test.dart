// test/unit/domain/usecases/ml/extract_symptoms_from_text_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/entities/symptom.dart';
import 'package:medmind/domain/usecases/ml/extract_symptoms_from_text.dart';

import '../../../../helpers/mock_repositories.dart';

void main() {
  late MockMlRepository mlRepo;
  late ExtractSymptomsFromText useCase;

  const extracted = [
    ExtractedSymptom(
      symptomName: 'headache',
      severity: 'mild',
      confidence: 0.9,
      sourceText: 'I have a headache',
      isConfirmedByUser: null,
    ),
  ];

  setUp(() {
    registerFallbackValues();
    mlRepo = MockMlRepository();
    useCase = ExtractSymptomsFromText(mlRepo);
  });

  group('ExtractSymptomsFromText', () {
    test('returns Right([]) for empty string without calling repo', () async {
      final result = await useCase('');

      expect(result, const Right(<ExtractedSymptom>[]));
      verifyZeroInteractions(mlRepo);
    });

    test(
      'returns Right([]) for whitespace-only string without calling repo',
      () async {
        final result = await useCase('   \t\n  ');

        expect(result, const Right(<ExtractedSymptom>[]));
        verifyZeroInteractions(mlRepo);
      },
    );

    test('delegates to mlRepo for non-empty text', () async {
      const text = 'I have a headache and feel tired';
      when(
        () => mlRepo.extractSymptomsFromText(text),
      ).thenAnswer((_) async => const Right(extracted));

      final result = await useCase(text);

      verify(() => mlRepo.extractSymptomsFromText(text)).called(1);
      expect(result.isRight(), isTrue);
      result.fold((_) => fail(''), (s) => expect(s, extracted));
    });

    test('forwards mlRepo failure', () async {
      const text = 'my head hurts';
      when(
        () => mlRepo.extractSymptomsFromText(text),
      ).thenAnswer((_) async => const Left(MLFailure('inference failed')));

      final result = await useCase(text);

      expect(result.isLeft(), isTrue);
      result.fold((f) => expect(f, isA<MLFailure>()), (_) => fail(''));
    });

    test('passes exact text string to repo', () async {
      const text = 'severe nausea after eating';
      when(
        () => mlRepo.extractSymptomsFromText(text),
      ).thenAnswer((_) async => const Right([]));

      await useCase(text);

      final captured = verify(
        () => mlRepo.extractSymptomsFromText(captureAny()),
      ).captured;
      expect(captured.single, text);
    });
  });
}
