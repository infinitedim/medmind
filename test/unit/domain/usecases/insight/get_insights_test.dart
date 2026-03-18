// test/unit/domain/usecases/insight/get_insights_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:medmind/core/enum/enum_collection.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/entities/insight.dart';
import 'package:medmind/domain/usecases/insight/get_insights.dart';

import '../../../../helpers/mock_repositories.dart';

void main() {
  late MockInsightRepository repo;
  late GetInsights useCase;

  final tInsights = [
    Insight(
      id: 'i1',
      type: InsightType.correlation,
      title: 'Sleep-Mood',
      description: 'Correlated',
      confidence: 0.9,
      relatedVariables: const ['sleep', 'mood'],
      generatedAt: DateTime(2026, 3, 1),
    ),
    Insight(
      id: 'i2',
      type: InsightType.anomaly,
      title: 'Anomaly',
      description: 'Detected',
      confidence: 0.8,
      relatedVariables: const ['symptoms'],
      generatedAt: DateTime(2026, 3, 2),
      isRead: true,
    ),
  ];

  setUp(() {
    registerFallbackValues();
    repo = MockInsightRepository();
    useCase = GetInsights(repo);
  });

  group('GetInsights', () {
    test('returns all insights when unreadOnly is false', () async {
      when(
        () => repo.getInsights(unreadOnly: false),
      ).thenAnswer((_) async => Right(tInsights));

      final result = await useCase(const GetInsightsParams());

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('Expected Right'), (list) {
        expect(list, hasLength(2));
        expect(list, tInsights);
      });
      verify(() => repo.getInsights(unreadOnly: false)).called(1);
    });

    test('passes unreadOnly=true to repository', () async {
      final unread = [tInsights.first];
      when(
        () => repo.getInsights(unreadOnly: true),
      ).thenAnswer((_) async => Right(unread));

      final result = await useCase(const GetInsightsParams(unreadOnly: true));

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (list) => expect(list, unread),
      );
      verify(() => repo.getInsights(unreadOnly: true)).called(1);
      verifyNever(() => repo.getInsights(unreadOnly: false));
    });

    test('returns empty list when there are no insights', () async {
      when(
        () => repo.getInsights(unreadOnly: false),
      ).thenAnswer((_) async => const Right([]));

      final result = await useCase(const GetInsightsParams());

      result.fold(
        (_) => fail('Expected Right'),
        (list) => expect(list, isEmpty),
      );
    });

    test('propagates DatabaseFailure from repository', () async {
      when(
        () => repo.getInsights(unreadOnly: false),
      ).thenAnswer((_) async => const Left(DatabaseFailure('read error')));

      final result = await useCase(const GetInsightsParams());

      expect(result.isLeft(), isTrue);
      result.fold((f) {
        expect(f, isA<DatabaseFailure>());
        expect(f.message, 'read error');
      }, (_) => fail('Expected Left'));
    });

    test('watch delegates to watchInsights stream', () {
      when(
        () => repo.watchInsights(),
      ).thenAnswer((_) => Stream.value(tInsights));

      final stream = useCase.watch();

      expect(stream, emits(tInsights));
      verify(() => repo.watchInsights()).called(1);
    });
  });
}
