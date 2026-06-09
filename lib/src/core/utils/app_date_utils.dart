import 'package:intl/intl.dart';

/// Date and time utilities for the Wedding Cards app.
/// Provides formatting helpers for wedding dates, countdowns, and relative times.
class AppDateUtils {
  AppDateUtils._();

  // ─── Wedding Date Formatting ──────────────────────────────────────

  /// Formats a date as a wedding-style date string.
  /// Example: "Saturday, 15 March 2025"
  static String formatWeddingDate(DateTime date) {
    return DateFormat('EEEE, d MMMM yyyy').format(date);
  }

  /// Formats a date as a short wedding date.
  /// Example: "15 Mar 2025"
  static String formatWeddingDateShort(DateTime date) {
    return DateFormat('d MMM yyyy').format(date);
  }

  /// Formats a date as "Month Day, Year".
  /// Example: "March 15, 2025"
  static String formatWeddingDateUS(DateTime date) {
    return DateFormat('MMMM d, yyyy').format(date);
  }

  // ─── Countdown Formatting ─────────────────────────────────────────

  /// Returns a countdown string showing days, hours, and minutes until the wedding.
  /// Returns "Today!" if the wedding is today.
  /// Returns "Passed" if the wedding date has passed.
  static String formatCountdown(DateTime weddingDate) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final weddingStart =
        DateTime(weddingDate.year, weddingDate.month, weddingDate.day);

    if (weddingStart.isBefore(todayStart)) {
      final daysAgo = todayStart.difference(weddingStart).inDays;
      if (daysAgo == 1) return '1 day ago';
      return '$daysAgo days ago';
    }

    final difference = weddingDate.difference(now);

    if (difference.inDays == 0 && difference.inHours <= 24) {
      if (difference.inHours > 0) {
        final hours = difference.inHours;
        final minutes = difference.inMinutes % 60;
        if (minutes > 0) {
          return '$hours ${_pluralize(hours, 'hour')}, $minutes ${_pluralize(minutes, 'min')}';
        }
        return '$hours ${_pluralize(hours, 'hour')}';
      }
      if (difference.inMinutes > 0) {
        return '${difference.inMinutes} ${_pluralize(difference.inMinutes, 'minute')}';
      }
      return 'Today!';
    }

    final days = difference.inDays;
    final hours = difference.inHours % 24;

    if (days > 365) {
      final years = days ~/ 365;
      final remainingMonths = (days % 365) ~/ 30;
      if (remainingMonths > 0) {
        return '$years ${_pluralize(years, 'year')}, $remainingMonths ${_pluralize(remainingMonths, 'month')}';
      }
      return '$years ${_pluralize(years, 'year')}';
    }

    if (days > 30) {
      final months = days ~/ 30;
      final remainingDays = days % 30;
      if (remainingDays > 0) {
        return '$months ${_pluralize(months, 'month')}, $remainingDays ${_pluralize(remainingDays, 'day')}';
      }
      return '$months ${_pluralize(months, 'month')}';
    }

    if (hours > 0) {
      return '$days ${_pluralize(days, 'day')}, $hours ${_pluralize(hours, 'hour')}';
    }

    return '$days ${_pluralize(days, 'day')}';
  }

  // ─── Relative Time (Time Ago) ─────────────────────────────────────

  /// Returns a human-readable "time ago" string.
  /// Example: "2 hours ago", "Just now", "3 days ago"
  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 30) {
      return 'Just now';
    }
    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    }
    if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${_pluralize(minutes, 'minute')} ago';
    }
    if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${_pluralize(hours, 'hour')} ago';
    }
    if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${_pluralize(days, 'day')} ago';
    }
    if (difference.inDays < 30) {
      final weeks = difference.inDays ~/ 7;
      return '$weeks ${_pluralize(weeks, 'week')} ago';
    }
    if (difference.inDays < 365) {
      final months = difference.inDays ~/ 30;
      return '$months ${_pluralize(months, 'month')} ago';
    }

    final years = difference.inDays ~/ 365;
    return '$years ${_pluralize(years, 'year')} ago';
  }

  // ─── Time Formatting ──────────────────────────────────────────────

  /// Formats a time as "10:30 AM".
  static String formatTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }

  /// Formats a time as "10:30".
  static String formatTime24(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  /// Formats a date and time together.
  /// Example: "15 Mar 2025, 10:30 AM"
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('d MMM yyyy, h:mm a').format(dateTime);
  }

  /// Formats a date as a simple date.
  /// Example: "15/03/2025"
  static String formatDateSimple(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  /// Formats as ISO 8601 date string.
  static String formatISO(DateTime dateTime) {
    return dateTime.toIso8601String();
  }

  // ─── Helpers ──────────────────────────────────────────────────────

  /// Returns 's' pluralized word if count != 1.
  static String _pluralize(int count, String word) {
    return count == 1 ? word : '${word}s';
  }

  /// Checks if a date is today.
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Checks if a date is in the future.
  static bool isFuture(DateTime date) {
    return date.isAfter(DateTime.now());
  }

  /// Checks if a date is in the past.
  static bool isPast(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  /// Returns the number of days between two dates.
  static int daysBetween(DateTime start, DateTime end) {
    final startDate = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day);
    return endDate.difference(startDate).inDays;
  }
}
