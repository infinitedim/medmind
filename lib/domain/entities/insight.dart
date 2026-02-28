import 'package:medmind/core/enum/enum_collection.dart';

class Insight {
  final String id;
  final InsightType type;
  final String title;
  final String description;
  final double confidence;
  final List<String> relatedVariables;
  final DateTime generatedAt;
  bool isRead;
  bool isSaved;

  Insight({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.confidence,
    required this.relatedVariables,
    required this.generatedAt,
    this.isRead = false,
    this.isSaved = false,
  });
}
