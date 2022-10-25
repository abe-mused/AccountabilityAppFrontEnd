class Community {
  String communityName;
  Map<int, int>? dailyCheckIns;
  String creator;
  int creationDate;
  List<dynamic> members;

  Community({required this.communityName, required this.creator, required this.creationDate, required this.members});

  factory Community.fromJson(Map<String, dynamic> item) {
    Community community = Community(
      communityName: item['communityName'],
      creator: item['creator'],
      creationDate: item['creationDate'],
      members: item['members'] ?? [],
    );
    if (item['dailyCheckIns'] != null) {
      community.dailyCheckIns = item['dailyCheckIns'];
    }
    return community;
  }
}
