import 'package:dartz/dartz.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/entities/journal_entry.dart';

class ExportParams {
  final List<JournalEntry> entries;

  final DateTime? startDate;
  final DateTime? endDate;

  const ExportParams({required this.entries, this.startDate, this.endDate});
}

abstract class PdfExportDataSource {
  Future<Either<Failure, String>> generate(ExportParams params);
}

class ExportToPdf {
  final PdfExportDataSource _dataSource;

  const ExportToPdf(this._dataSource);

  Future<Either<Failure, String>> call(ExportParams params) {
    if (params.entries.isEmpty) {
      return Future.value(
        const Left(ValidationFailure('No entries to export')),
      );
    }
    return _dataSource.generate(params);
  }
}
