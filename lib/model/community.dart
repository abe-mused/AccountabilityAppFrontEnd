class Community {
  String communityName;
  String creator;
  int creationDate;
  List<dynamic> members;
  List<dynamic> checkIns;

  Community({required this.communityName, required this.creator, required this.creationDate, required this.members, required this.checkIns});

  factory Community.fromJson(Map<String, dynamic> item) {
    Community community = Community(
      communityName: item['communityName'],
      creator: item['creator'],
      creationDate: item['creationDate'],
      members: item['members'] ?? [],
      checkIns: item['checkIns'] ?? [],
    );
    return community;
  }
}
