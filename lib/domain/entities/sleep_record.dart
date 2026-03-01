import 'package:freezed_annotation/freezed_annotation.dart';

part 'sleep_record.freezed.dart';

@freezed
abstract class SleepRecord with _$SleepRecord {
  const SleepRecord._();

  const factory SleepRecord({
    required DateTime bedTime,
    required DateTime wakeTime,
    required int quality, // 1-10
    int? disturbances, // berapa kali terbangun
  }) = _SleepRecord;

  Duration get duration => wakeTime.difference(bedTime);
}
