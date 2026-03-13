import 'package:intl/intl.dart';

extension MedMindDateExtensions on DateTime {
  DateTime toStartOfDay() => DateTime(year, month, day);

  DateTime toEndOfDay() => DateTime(year, month, day, 23, 59, 59, 999, 999);

  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
}

abstract final class AppDateUtils {
  static String formatReadable(DateTime date) =>
      DateFormat('d MMM yyyy').format(date);

  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = today.difference(target).inDays;
    if (diff == 0) return 'Hari ini';
    if (diff == 1) return 'Kemarin';
    if (diff < 7) return '$diff hari lalu';
    return formatReadable(date);
  }

  static List<DateTime> lastNDays(int n) {
    assert(n > 0);
    final today = DateTime.now().toStartOfDay();
    return List.generate(n, (i) => today.subtract(Duration(days: n - 1 - i)));
  }
}
