import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:medmind/core/utils/date_utils.dart';

void main() {
  group('MedMindDateExtensions.toStartOfDay', () {
    test('zeroes out time components', () {
      final dt = DateTime(2024, 6, 15, 14, 30, 45, 123, 456);
      final start = dt.toStartOfDay();
      expect(start, DateTime(2024, 6, 15));
      expect(start.hour, 0);
      expect(start.minute, 0);
      expect(start.second, 0);
      expect(start.millisecond, 0);
    });
  });

  group('MedMindDateExtensions.toEndOfDay', () {
    test('sets time to 23:59:59.999999', () {
      final dt = DateTime(2024, 6, 15);
      final end = dt.toEndOfDay();
      expect(end.hour, 23);
      expect(end.minute, 59);
      expect(end.second, 59);
      expect(end.millisecond, 999);
      expect(end.microsecond, 999);
    });
  });

  group('MedMindDateExtensions.isSameDay', () {
    test('same day returns true', () {
      final a = DateTime(2024, 3, 10, 9, 0);
      final b = DateTime(2024, 3, 10, 23, 59);
      expect(a.isSameDay(b), isTrue);
    });

    test('different day returns false', () {
      final a = DateTime(2024, 3, 10);
      final b = DateTime(2024, 3, 11);
      expect(a.isSameDay(b), isFalse);
    });

    test('different month returns false', () {
      final a = DateTime(2024, 3, 10);
      final b = DateTime(2024, 4, 10);
      expect(a.isSameDay(b), isFalse);
    });

    test('different year returns false', () {
      final a = DateTime(2024, 3, 10);
      final b = DateTime(2025, 3, 10);
      expect(a.isSameDay(b), isFalse);
    });
  });

  group('AppDateUtils.formatReadable', () {
    test('formats date in d MMM yyyy pattern', () {
      final date = DateTime(2024, 1, 5);
      final result = AppDateUtils.formatReadable(date);
      expect(result, contains('2024'));
    });

    test('uses intl DateFormat d MMM yyyy', () {
      final date = DateTime(2024, 6, 15);
      expect(
        AppDateUtils.formatReadable(date),
        DateFormat('d MMM yyyy').format(date),
      );
    });
  });

  group('AppDateUtils.formatRelative', () {
    test('returns "Hari ini" for today', () {
      expect(AppDateUtils.formatRelative(DateTime.now()), 'Hari ini');
    });

    test('returns "Kemarin" for yesterday', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      expect(AppDateUtils.formatRelative(yesterday), 'Kemarin');
    });

    test('returns "<n> hari lalu" for 3 days ago', () {
      final threeDaysAgo = DateTime.now().subtract(const Duration(days: 3));
      expect(AppDateUtils.formatRelative(threeDaysAgo), '3 hari lalu');
    });

    test('returns readable date for dates older than 7 days', () {
      final oldDate = DateTime(2020, 1, 15);
      expect(
        AppDateUtils.formatRelative(oldDate),
        AppDateUtils.formatReadable(oldDate),
      );
    });
  });

  group('AppDateUtils.lastNDays', () {
    test('returns list of exactly n days', () {
      expect(AppDateUtils.lastNDays(7).length, 7);
      expect(AppDateUtils.lastNDays(30).length, 30);
    });

    test('last element is today (start of day)', () {
      final days = AppDateUtils.lastNDays(5);
      final today = DateTime.now().toStartOfDay();
      expect(days.last, today);
    });

    test('list is ordered oldest to newest', () {
      final days = AppDateUtils.lastNDays(3);
      expect(days[0].isBefore(days[1]), isTrue);
      expect(days[1].isBefore(days[2]), isTrue);
    });

    test('consecutive days differ by exactly 1 day', () {
      final days = AppDateUtils.lastNDays(5);
      for (int i = 1; i < days.length; i++) {
        final diff = days[i].difference(days[i - 1]).inDays;
        expect(diff, 1);
      }
    });
  });
}
