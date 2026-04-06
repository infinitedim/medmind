import 'dart:convert';

import 'package:medmind/data/models/insight_model.dart';
import 'package:medmind/domain/entities/insight.dart';

extension InsightModelMapper on InsightModel {
  Insight toDomain() => Insight(
    id: uid,
    type: type,
    title: title,
    description: description,
    confidence: confidence,
    relatedVariables: (jsonDecode(relatedVariablesJson) as List).cast<String>(),
    generatedAt: generatedAt,
    isRead: isRead,
    isSaved: isSaved,
  );
}

extension InsightDomainMapper on Insight {
  InsightModel toModel() => InsightModel()
    ..uid = id
    ..type = type
    ..title = title
    ..description = description
    ..confidence = confidence
    ..relatedVariablesJson = jsonEncode(relatedVariables)
    ..generatedAt = generatedAt
    ..isRead = isRead
    ..isSaved = isSaved;
}
