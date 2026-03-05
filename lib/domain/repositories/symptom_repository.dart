import 'package:dartz/dartz.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/entities/symptom.dart';

abstract class SymptomRepository {
  Future<Either<Failure, List<Symptom>>> getAllSymptoms();
  Future<Either<Failure, List<Symptom>>> getSelectedSymptoms();
  Future<Either<Failure, Symptom>> createSymptom(Symptom symptom);
  Future<Either<Failure, Symptom>> updateSymptom(Symptom symptom);
  Future<Either<Failure, void>> deleteSymptom(String id);
  Future<Either<Failure, void>> setSelectedSymptoms(List<String> symptomIds);
  Stream<List<Symptom>> watchSelectedSymptoms();
}
