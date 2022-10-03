class Community {
  String communityName;
  Map<int, int>? dailyCheckIns;
  String creator;
  int creationDate;

  Community({required this.communityName, required this.creator, required this.creationDate});

  factory Community.fromJson(Map<String, dynamic> item) {
    Community community = Community(
      communityName: item['communityName'],
      creator: item['creator'],
      creationDate: item['creationDate'],
    );
    if (item['dailyCheckIns'] == null) {
      community.dailyCheckIns = item['dailyCheckIns'];
    }
    return community;
  }
}
