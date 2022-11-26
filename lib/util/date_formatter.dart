import 'package:intl/intl.dart';

final f_date = DateFormat().add_yMMMEd();
final f_time = DateFormat().add_jm();
const dayInMilliseconds = 86400000;

String dateFormat = "'EEE, MMM d, ''yy'";

String getFormattedDateF(int unixTimeMilliseconds) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(unixTimeMilliseconds);
  return "${f_date.format(date)} at ${f_time.format(date)}";
}

String getFormattedDate(int unixTimeMilliseconds) {
  DateTime currentDate = DateTime.now();
  DateTime inputDate = DateTime.fromMillisecondsSinceEpoch(unixTimeMilliseconds);

  int difference;
  if(inputDate.isAfter(currentDate.subtract(const Duration(hours:1)))){
    return "Created < 1 hour ago";
  } 
  if(inputDate.isAfter(currentDate.subtract(const Duration(days:2)))){
    difference = (currentDate.difference(inputDate).inHours).round();
    return "Created ${difference.toString()} hour${difference > 1? "s" : ""} ago";
  }
  return "Created ${(currentDate.difference(inputDate).inDays).round()} days ago";
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
