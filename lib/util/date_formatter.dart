import 'package:intl/intl.dart';

final f_date = DateFormat().add_yMMMEd();
final f_time = DateFormat().add_jm();
const dayInMilliseconds = 86400000;

String dateFormat = "'EEE, MMM d, ''yy'";

String getFormattedDate(int unixTimeMilliseconds) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(unixTimeMilliseconds);
  return "${f_date.format(date)} at ${f_time.format(date)}";
}

computeStreak(firstStreakEpoch, lastStreakEpoch, currentEpoch) {
  firstStreakEpoch = firstStreakEpoch is int? firstStreakEpoch : int.parse(firstStreakEpoch);
  firstStreakEpoch = lastStreakEpoch is int? lastStreakEpoch : int.parse(lastStreakEpoch);
  if (currentEpoch - dayInMilliseconds < lastStreakEpoch) {
    int streak = (lastStreakEpoch - firstStreakEpoch) ~/ dayInMilliseconds;
    return streak;
  } else {
    return 0;
  }
}
