import 'dart:io';
import 'package:csv/csv.dart';
import 'package:dartz/dartz.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/usecases/export/export_to_csv.dart';
import 'package:medmind/domain/usecases/export/export_to_pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class CsvExportDataSourceImpl implements CsvExportDataSource {
  const CsvExportDataSourceImpl();

  @override
  Future<Either<Failure, String>> generate(ExportParams params) async {
    try {
      final headers = [
        'Date',
        'Mood',
        'Intensity',
        'Sleep Quality',
        'Sleep Duration (min)',
        'Symptoms',
        'Medications',
        'Notes'
      ];

      final rows = params.entries.map((e) {
        return [
          e.date.toIso8601String().split('T').first,
          e.mood?.name ?? '',
          e.moodIntensity ?? '',
          e.sleepRecord?.quality ?? '',
          e.sleepRecord?.duration.inMinutes ?? '',
          e.symptoms.map((s) => '${s.symptomId}(${s.severity})').join('; '),
          e.medications.map((m) => m.medicationId).join('; '),
          e.freeText ?? '',
        ];
      }).toList();

      final csvData = csv.encode([headers, ...rows]);
      
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/medmind_export_${DateTime.now().millisecondsSinceEpoch}.csv');
      await file.writeAsString(csvData);
      
      return Right(file.path);
    } catch (e) {
      return Left(ExportFailure('Failed to generate CSV: ${e.toString()}'));
    }
  }
}

class PdfExportDataSourceImpl implements PdfExportDataSource {
  const PdfExportDataSourceImpl();

  @override
  Future<Either<Failure, String>> generate(ExportParams params) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Text(
                'MedMind Health Report',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Paragraph(
              text: 'Report generated on: ${DateTime.now().toString().split('.').first}',
            ),
            pw.Divider(),
            pw.TableHelper.fromTextArray(
              headers: ['Date', 'Mood', 'Sleep', 'Symptoms'],
              data: params.entries.map((e) {
                return [
                  e.date.toString().split(' ').first,
                  '${e.mood?.name ?? "-"}, ${e.moodIntensity ?? "-"}',
                  '${e.sleepRecord?.quality ?? "-"}',
                  e.symptoms.length.toString(),
                ];
              }).toList(),
            ),
          ],
        ),
      );

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/medmind_report_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(await pdf.save());

      return Right(file.path);
    } catch (e) {
      return Left(ExportFailure('Failed to generate PDF: ${e.toString()}'));
    }
  }
}

