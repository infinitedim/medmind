import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medmind/core/errors/exceptions.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/data/datasources/local/symptom_local_datasource.dart';
import 'package:medmind/data/mappers/symptom_mapper.dart';
import 'package:medmind/domain/entities/symptom.dart';
import 'package:medmind/domain/repositories/symptom_repository.dart';

@LazySingleton(as: SymptomRepository)
class SymptomRepositoryImpl implements SymptomRepository {
  const SymptomRepositoryImpl(this._dataSource, this._prefs);

  final SymptomLocalDataSource _dataSource;
  final SharedPreferences _prefs;

  static const _selectedKey = 'selected_symptom_ids';

  List<String> _selectedIds() => _prefs.getStringList(_selectedKey) ?? const [];

  @override
  Future<Either<Failure, List<Symptom>>> getAllSymptoms() async {
    try {
      final models = await _dataSource.getAll();
      return Right(models.map((m) => m.toDomain()).toList());
    } on AppException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Symptom>>> getSelectedSymptoms() async {
    try {
      final ids = _selectedIds();
      if (ids.isEmpty) return const Right([]);
      final all = await _dataSource.getAll();
      return Right(
        all.where((m) => ids.contains(m.uid)).map((m) => m.toDomain()).toList(),
      );
    } on AppException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Symptom>> createSymptom(Symptom symptom) async {
    try {
      await _dataSource.save(symptom.toModel());
      return Right(symptom);
    } on AppException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Symptom>> updateSymptom(Symptom symptom) async {
    try {
      final existing = await _dataSource.getByUid(symptom.id);
      final model = symptom.toModel()..id = existing.id;
      await _dataSource.save(model);
      return Right(symptom);
    } on RecordNotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on AppException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSymptom(String id) async {
    try {
      await _dataSource.deleteByUid(id);
      return const Right(null);
    } on RecordNotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on AppException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> setSelectedSymptoms(
    List<String> symptomIds,
  ) async {
    try {
      await _prefs.setStringList(_selectedKey, symptomIds);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Gagal menyimpan selected symptoms: $e'));
    }
  }

  @override
  Stream<List<Symptom>> watchSelectedSymptoms() {
    return _dataSource.watchAll().map((models) {
      final ids = _selectedIds();
      return models
          .where((m) => ids.contains(m.uid))
          .map((m) => m.toDomain())
          .toList();
    });
  }
}
