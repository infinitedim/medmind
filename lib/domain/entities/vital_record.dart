import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medmind/core/enum/enum_collection.dart';

part 'vital_record.freezed.dart';

@freezed
abstract class VitalRecord with _$VitalRecord {
  const factory VitalRecord({
    int? heartRate,
    int? steps,
    double? weight,
    double? spO2,
    required DateTime date,
    required VitalSource source,
  }) = _VitalRecord;
}
