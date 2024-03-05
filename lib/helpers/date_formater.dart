import 'package:intl/intl.dart';

class DateTimeHelper {
  static String formatDateTime(DateTime dateTime) {
    return DateFormat("yyyy-MM-dd HH:mm").format(dateTime);
  }

  static String formatDateTimeOnlyTime(DateTime dateTime) {
    return DateFormat("HH:mm").format(dateTime);
  }

  static String formatDateTimeOnlyDate(DateTime dateTime) {
    return DateFormat("yyyy-MM-dd").format(dateTime);
  }
}
