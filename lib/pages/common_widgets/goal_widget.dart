import 'package:flutter/material.dart';
import 'package:linear/model/goal.dart';
import 'package:linear/pages/community_page.dart';
import 'package:linear/util/date_formatter.dart';
import 'package:linear/util/apis.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class GoalWidget extends StatelessWidget {
  const GoalWidget({super.key, required this.goal, required this.onDelete/*, required this.route*/});
  final Goal goal;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    
    final ScrollController scrollController = ScrollController();
    
    doDeleteGoal() {
      final Future<Map<String, dynamic>> responseMessage = deleteGoal(context, goal.goalId);
      responseMessage.then((response) {
        if (response['status'] == true) {
        onDelete();
        } else {}
      });
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Card(
        margin: const EdgeInsets.only(top: 10.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              buildGoalWidgetHeader(context, doDeleteGoal),
              const Divider(
                height: 10,
                thickness: 0.6,
                indent: 0,
                endIndent: 0,
              ),
              buildGoalWidgetBody(),
            ],
          ),
        ),
      ),
    );
  }

  Container buildGoalWidgetHeader(BuildContext context, Null doDeleteGoal()) {
    return Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CommunityPage(
                                  communityName: goal.communityName,
                                ),
                              ),
                            );
                          },
                        child: Text(
                          "c/${goal.communityName}",
                          style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                        Text(
                          getFormattedDate(goal.creationDate),
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                   //if (goal.creator == user!.username) ... [
                    PopupMenuButton(itemBuilder: (context) {
                    return [
                      const PopupMenuItem<int>(
                        value: 0,
                        child: Text("Delete"),
                      ),
                    ];
                  }, onSelected: (value) {
                    if (value == 0) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Delete'),
                          content: const Text('Are you sure you want to delete this goal?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () =>
                                Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                            ),
                            
                            TextButton( 
                              onPressed: () {
                                doDeleteGoal();
                                Navigator.pop(context);
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        ),
                      );
                    }
                  }),
                ],
              ),
            );
  }

  buildGoalWidgetBody() { 
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircularPercentIndicator(
            radius: 45.0,
            lineWidth: 8.0,
            progressColor: Colors.green,
            circularStrokeCap: CircularStrokeCap.round,
            animation: true,
            percent: goal.completedCheckIns/goal.checkInGoal,
            center: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  "${((goal.completedCheckIns/goal.checkInGoal) * 100).round()}%",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                ),
                const SizedBox(height: 5),
                const Divider(
                  height: 0.1,
                  color: Colors.grey,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                const SizedBox(height: 5),
                Text(
                  "${goal.completedCheckIns}/${goal.checkInGoal}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                )
              ]
            ),
            // footer: 
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 0),
              child: Text(
                goal.goalBody,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      )
    );
  }
}