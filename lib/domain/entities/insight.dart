import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medmind/core/enum/enum_collection.dart';

part 'insight.freezed.dart';

@freezed
abstract class Insight with _$Insight {
  const factory Insight({
    required String id,
    required InsightType type,
    required String title,
    required String description,
    required double confidence,
    required List<String> relatedVariables,
    required DateTime generatedAt,
    @Default(false) bool isRead,
    @Default(false) bool isSaved,
  }) = _Insight;
}
