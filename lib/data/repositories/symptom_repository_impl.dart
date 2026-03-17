import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:medmind/core/errors/exceptions.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/data/datasources/local/symptom_local_datasource.dart';
import 'package:medmind/data/mappers/symptom_mapper.dart';
import 'package:medmind/domain/entities/symptom.dart';
import 'package:medmind/domain/repositories/symptom_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: SymptomRepository)
class SymptomRepositoryImpl implements SymptomRepository {
  const SymptomRepositoryImpl(this._datasource, this._prefs);

  final SymptomLocalDataSource _datasource;
  final SharedPreferences _prefs;

  static const _selectedKey = 'selected_symptom_ids';

  List<String> _selectedIds() {
    return _prefs.getStringList(_selectedKey) ?? [];
  }

  @override
  Future<Either<Failure, List<Symptom>>> getAllSymptoms() async {
    try {
      final models = await _datasource.getAll();
      return Right(models.map((m) => m.toDomain()).toList());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Symptom>>> getSelectedSymptoms() async {
    try {
      final ids = _selectedIds();
      final all = await _datasource.getAll();
      final selected = all
          .where((m) => ids.contains(m.uid))
          .map((m) => m.toDomain())
          .toList();
      return Right(selected);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Symptom>> createSymptom(Symptom symptom) async {
    try {
      final model = symptom.toModel();
      await _datasource.save(model);
      return Right(symptom);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Symptom>> updateSymptom(Symptom symptom) async {
    try {
      final existing = await _datasource.getByUid(symptom.id);
      final model = symptom.toModel()..id = existing.id;
      await _datasource.save(model);
      return Right(symptom);
    } on RecordNotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSymptom(String id) async {
    try {
      await _datasource.deleteByUid(id);
      return const Right(null);
    } on RecordNotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> setSelectedSymptoms(
    List<String> symptomIds,
  ) async {
    await _prefs.setStringList(_selectedKey, symptomIds);
    return const Right(null);
  }

  @override
  Stream<List<Symptom>> watchSelectedSymptoms() {
    final ids = _selectedIds();
    return _datasource.watchAll().map(
      (models) => models
          .where((m) => ids.contains(m.uid))
          .map((m) => m.toDomain())
          .toList(),
    );
  }
}
