import 'package:intl/intl.dart';

class MyDateTime {
  static DateTime dateFormat(String time) {
    var dt = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return DateTime(dt.year, dt.month, dt.day);
  }

  static String timeDate(String time) {
    String t = '';
    var dt = DateTime.fromMicrosecondsSinceEpoch(int.parse(time));
    t = DateFormat('jm').format(dt).toString();

    return t;
  }

  static String dateAndTime(String time) {
    var dt = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    String dat = '';
    final now = DateTime.now();
    final yesterday = DateTime.now().add(Duration(days: -1));
    final toDay = DateTime(now.year, now.month, now.day);
    final yesterDay = DateTime(yesterday.year, yesterday.month, yesterday.day);
    final data = DateTime(dt.year, dt.month, dt.day);

    if (data == toDay) {
      dat = "today";
    } else if (data == yesterDay) {
      dat = "yesterday";
    } else if (dt.year == now.year) {
      dat = DateFormat.MMMd().format(dt).toString();
    } else {
      dat = DateFormat.yMMMd().format(dt).toString();
    }

    print(dat);
    return dat;
  }
}
