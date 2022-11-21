import 'package:intl/intl.dart';

final f_date = DateFormat().add_yMMMEd();
final f_time = DateFormat().add_jm();
const dayInMilliseconds = 86400000;

String dateFormat = "'EEE, MMM d, ''yy'";

String getFormattedDate(int unixTimeMilliseconds) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(unixTimeMilliseconds);
  return "${f_date.format(date)} at ${f_time.format(date)}";
}

int computeStreak(firstStreakEpoch, lastStreakEpoch) {
  firstStreakEpoch = firstStreakEpoch is int? firstStreakEpoch : int.parse(firstStreakEpoch);
  lastStreakEpoch = lastStreakEpoch is int? lastStreakEpoch : int.parse(lastStreakEpoch);
  
  if (DateTime.now().isBefore(DateTime.fromMillisecondsSinceEpoch(lastStreakEpoch).add(const Duration(days: 1, hours: 12)))) {
    return (lastStreakEpoch - firstStreakEpoch) ~/ dayInMilliseconds;
  } else {
    return 0;
  }
}
