class Goal {
  String communityName;
  String goalId;
  String creator;
  int creationDate;
  String goalBody;
  int checkInGoal;
  int completedCheckIns;

  Goal({
    required this.communityName,
    required this.goalId,
    required this.creator,
    required this.creationDate,
    required this.goalBody,
    required this.checkInGoal,
    required this.completedCheckIns
  }); 
  

  factory Goal.fromJson(Map<String, dynamic> item) {
    Goal goal = Goal(
      communityName: item['community'],
      goalId: item['goalId'],
      creator: item['creator'],
      creationDate: item['creationDate'],
      checkInGoal: item['checkInGoal'],
      goalBody: item['goalBody'], 
      completedCheckIns: item['completedCheckIns'],
    );
    return goal;
  }
}
