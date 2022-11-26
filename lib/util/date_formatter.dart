const dayInMilliseconds = 86400000;

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
