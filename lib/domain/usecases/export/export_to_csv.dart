import 'package:dartz/dartz.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/usecases/export/export_to_pdf.dart';

abstract class CsvExportDataSource {
  Future<Either<Failure, String>> generate(ExportParams params);
}

class ExportToCsv {
  final CsvExportDataSource _dataSource;

  const ExportToCsv(this._dataSource);

  Future<Either<Failure, String>> call(ExportParams params) {
    if (params.entries.isEmpty) {
      return Future.value(
        const Left(ValidationFailure('No entries to export')),
      );
    }
    return _dataSource.generate(params);
  }
}
