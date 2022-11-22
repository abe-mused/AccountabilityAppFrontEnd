import 'package:flutter/material.dart';
import 'package:linear/model/goal.dart';
import 'package:linear/pages/community_page.dart';
import 'package:linear/util/date_formatter.dart';
import 'package:linear/util/apis.dart';

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
        margin: const EdgeInsets.only(top: 20.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Container(
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
              ),
              const Divider(
                height: 10,
                thickness: 0.6,
                indent: 0,
                endIndent: 0,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total days to complete goal: ${goal.checkInGoal.toString()}",
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                   "Total days completed: ${goal.completedCheckIns.toString()}",
                                   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                   textAlign: TextAlign.center,
                                 ),
                                const SizedBox(height: 5),
                                if (goal.goalBody.length > 300) ...[
                                  SizedBox(
                                    height: 200,
                                    child: Scrollbar(
                                      thumbVisibility: true,
                                      controller: scrollController,
                                      child: Material(
                                        child: SingleChildScrollView(
                                          controller: scrollController,
                                          child: Text(
                                            goal.goalBody,
                                            style: const TextStyle(fontSize: 16),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ] else ...[
                                  Text(
                                    "Goal: ${goal.goalBody}",
                                    style: const TextStyle(fontSize: 16),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 1000,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}