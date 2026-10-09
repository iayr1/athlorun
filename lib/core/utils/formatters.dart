import 'package:intl/intl.dart';

class Fmt {
  static final _int = NumberFormat.decimalPattern();

  static String steps(int value) => _int.format(value);

  static String km(double value) => value.toStringAsFixed(2);

  static String duration(Duration d) {
    final h = d.inHours;
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  static String pace(double? minPerKm) {
    if (minPerKm == null || minPerKm.isInfinite || minPerKm > 99) {
      return '--:--';
    }
    final minutes = minPerKm.floor();
    final seconds = ((minPerKm - minutes) * 60).round().clamp(0, 59);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  static String date(DateTime d) => DateFormat('EEE, d MMM').format(d);

  static String time(DateTime d) => DateFormat('h:mm a').format(d);

  static String weekday(DateTime d) =>
      DateFormat('E').format(d).substring(0, 1);

  static String greeting(DateTime now) {
    if (now.hour < 12) return 'Good morning';
    if (now.hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}
