import 'package:intl/intl.dart';

final f_date = DateFormat().add_yMMMEd();
final f_time = DateFormat().add_jm();

String dateFormat = "'EEE, MMM d, ''yy'";

String getFormattedDate(int unixTimeMilliseconds) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(unixTimeMilliseconds);
  return "${f_date.format(date)} at ${f_time.format(date)}";
}
