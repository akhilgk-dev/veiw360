import 'package:intl/intl.dart';

class DateHelper {
  // Format a DateTime object to a string
  static String formatDate(DateTime date, {String format = 'dd/MM/yyyy'}) {
    final DateFormat formatter = DateFormat(format);
    return formatter.format(date);
  }

  static String formatShortMonthDay(DateTime date) {
    return DateFormat('MMM d').format(date); // e.g., "Aug 13"
  }

  // Format a DateTime object to a string with time
  static String formatDateTime(
    DateTime date, {
    String format = 'dd/MM/yyyy HH:mm',
  }) {
    final DateFormat formatter = DateFormat(format);
    return formatter.format(date);
  }

  // Format a DateTime object to a string in long format
  static String formatLongDate(DateTime date) {
    final DateFormat formatter = DateFormat('EEEE, d MMMM y');
    return formatter.format(date);
  }

  // Format a DateTime object to a string in short format
  static String formatShortDate(DateTime date) {
    final DateFormat formatter =
        DateFormat.yMd(); // Locale-specific short date format
    return formatter.format(date);
  }

  // Parse a string to a DateTime object
  static DateTime? parseDate(
    String dateString, {
    String format = 'dd/MM/yyyy',
  }) {
    try {
      final DateFormat formatter = DateFormat(format);
      return formatter.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  // Parse a string with time to a DateTime object
  static DateTime? parseDateTime(
    String dateString, {
    String format = 'dd/MM/yyyy HH:mm',
  }) {
    try {
      final DateFormat formatter = DateFormat(format);
      return formatter.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  // Get the difference between two DateTime objects in days
  static int getDifferenceInDays(DateTime startDate, DateTime endDate) {
    return endDate.difference(startDate).inDays;
  }

  // Check if a date is in the future
  static bool isFutureDate(DateTime date) {
    return date.isAfter(DateTime.now());
  }

  // Check if a date is in the past
  static bool isPastDate(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  // Get the start of the day from a DateTime object
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Get the end of the day from a DateTime object
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  // Format a date to a string in a localized format
  static String formatDateLocalized(DateTime date, {String? locale}) {
    final DateFormat formatter = DateFormat.yMMMMd(locale ?? 'en_US');
    return formatter.format(date);
  }

  // Get the current date and time formatted as a string
  static String getCurrentDateTimeFormatted({
    String format = 'dd/MM/yyyy HH:mm',
  }) {
    return formatDateTime(DateTime.now(), format: format);
  }

  // Format a DateTime object to a string with custom locale
  static String formatWithLocale(DateTime date, String locale) {
    final DateFormat formatter = DateFormat.yMMMMd(locale);
    return formatter.format(date);
  }

  // Convert a DateTime to Unix timestamp
  static int toUnixTimestamp(DateTime date) {
    return date.millisecondsSinceEpoch ~/ 1000;
  }

  // Convert a Unix timestamp to DateTime
  static DateTime fromUnixTimestamp(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  }

  // Get the current time formatted as a string
  static String getCurrentTimeFormatted({String format = 'HH:mm'}) {
    return formatDateTime(DateTime.now(), format: format);
  }

  static String getArabicDay(String day) {
    switch (day.toLowerCase()) {
      case 'sunday':
        return 'الأحد';
      case 'monday':
        return 'الاثنين';
      case 'tuesday':
        return 'الثلاثاء';
      case 'wednesday':
        return 'الأربعاء';
      case 'thursday':
        return 'الخميس';
      case 'friday':
        return 'الجمعة';
      case 'saturday':
        return 'السبت';
      default:
        return day; // fallback
    }
  }
}
