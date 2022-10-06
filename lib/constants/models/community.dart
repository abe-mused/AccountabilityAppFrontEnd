class Community {
  
  String communityName;
  Map<int, int> ?dailyCheckIns;
 // String date;
  //int check_ins;
  String creator;
  String creationDate;
  
  Community({required this.communityName,  required this.creator, required this.creationDate});

  factory Community.fromJson(Map<String, dynamic> item) {
    Community community = Community(
      communityName: item['communityName'],
      // date: item['date'],
      creator: item['creator'],
      creationDate: item['creationDate'],
    );
    if(item['dailyCheckIns'] == null){
      community.dailyCheckIns= item['dailyCheckIns'];
    }
    return community;
  }
}