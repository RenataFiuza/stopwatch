import 'package:intl/intl.dart';

class TimeFormat {

  static String mmssSSS(Duration d) {
    final ms = d.inMilliseconds;
    final minutes = (ms ~/ 60000).toString().padLeft(2, '0');
    final seconds = ((ms % 60000) ~/ 1000).toString().padLeft(2, '0');
    final millis  = (ms % 1000).toString().padLeft(3, '0');
    return '$minutes:$seconds.$millis';
  }

  
  static String stamp(DateTime dt) {
    return DateFormat.yMMMd().add_Hms().format(dt);
  }
}
