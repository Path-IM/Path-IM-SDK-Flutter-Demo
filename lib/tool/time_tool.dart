import 'package:intl/intl.dart';

class TimeTool {
  static String formatMessageTimestamp(int timestamp) {
    if (timestamp <= 0) {
      return "error";
    }
    DateTime time = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime now = DateTime.now();
    if (time.year == now.year && time.month == now.month) {
      if (time.day == now.day) {
        return DateFormat("HH:mm").format(time);
      } else {
        return DateFormat("MM-dd HH:mm").format(time);
      }
    } else {
      return DateFormat("yyyy-MM-dd HH:mm").format(time);
    }
  }
}
