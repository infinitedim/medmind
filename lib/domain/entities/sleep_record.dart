class SleepRecord {
  final DateTime bedTime;
  final DateTime wakeTime;
  final int quality; // 1-10
  final int? disturbances; // berapa kali terbangun

  SleepRecord({
    required this.bedTime,
    required this.wakeTime,
    required this.quality,
    this.disturbances,
  });

  Duration get duration => wakeTime.difference(bedTime);
}
