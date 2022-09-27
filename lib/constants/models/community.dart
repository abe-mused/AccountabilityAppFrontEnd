class Community {
  
  String communityName;
  int daily_check_ins;
  String date;
  int check_ins;
  String creator;
  String creation_date;
  
  Community({required this.communityName, required this.daily_check_ins, required this.date, required this.check_ins, required this.creator, required this.creation_date});

  factory Community.fromJson(Map<String, dynamic> item) {
    return Community(
      communityName: item['communityName'],
      daily_check_ins: item['daily_check_ins'],
      date: item['date'],
      check_ins: item['check_ins'],
      creator: item['creator'],
      creation_date: item['creation_date'],
    );
  }
}
