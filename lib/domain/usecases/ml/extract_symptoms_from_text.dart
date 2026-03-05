import 'package:dartz/dartz.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/entities/symptom.dart';
import 'package:medmind/domain/repositories/ml_repository.dart';

class ExtractSymptomsFromText {
  final MlRepository _repository;

  const ExtractSymptomsFromText(this._repository);

  Future<Either<Failure, List<ExtractedSymptom>>> call(String text) {
    if (text.trim().isEmpty) return Future.value(const Right([]));
    return _repository.extractSymptomsFromText(text);
  }
}
