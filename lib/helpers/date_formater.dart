import 'package:intl/intl.dart';

class DateTimeHelper {
  static String formatDateTime(DateTime dateTime) {
    return DateFormat("yyyy-MM-dd HH:mm").format(dateTime);
  }
}
