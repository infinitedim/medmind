// lib/data/models/insight_model.dart
import 'package:isar/isar.dart';
import 'package:medmind/core/enum/enum_collection.dart';

part 'insight_model.g.dart';

@Collection()
class InsightModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uid;

  @Enumerated(EnumType.name)
  late InsightType type;

  late String title;
  late String description;
  late double confidence;
  late String relatedVariablesJson;
  late DateTime generatedAt;
  late bool isRead;
  late bool isSaved;
}
