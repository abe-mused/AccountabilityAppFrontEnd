class Goal {
  String communityName;
  String goalId;
  String creator;
  int creationDate;
  String goalBody;
  int checkInGoal;
  int completedCheckIns;
  bool isFinished;

  Goal({
    required this.communityName,
    required this.goalId,
    required this.creator,
    required this.creationDate,
    required this.goalBody,
    required this.checkInGoal,
    required this.completedCheckIns,
    required this.isFinished
  }); 
  
  factory Goal.fromJson(Map<String, dynamic> item) {
    Goal goal = Goal(
      communityName: item['community'],
      goalId: item['goalId'],
      creator: item['creator'],
      creationDate: item['creationDate'] is int? item['creationDate'] : int.parse(item['creationDate']),
      checkInGoal: item['checkInGoal'] is int? item['checkInGoal'] : int.parse(item['checkInGoal']),
      goalBody: item['goalBody'], 
      completedCheckIns: item['completedCheckIns'] is int? item['completedCheckIns'] : int.parse(item['completedCheckIns']),
      isFinished: item['isFinished'], 
    );
    return goal;
  }
}