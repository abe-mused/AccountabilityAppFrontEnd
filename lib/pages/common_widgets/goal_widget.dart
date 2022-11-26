import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:linear/constants/themeSettings.dart';
import 'package:linear/model/goal.dart';
import 'package:linear/pages/community_page/community_page.dart';
import 'package:linear/util/date_formatter.dart';
import 'package:linear/util/apis.dart' as api;
import 'package:percent_indicator/circular_percent_indicator.dart';
import "package:flutter/services.dart";


class GoalWidget extends StatelessWidget {
  const GoalWidget({super.key, required this.goal, required this.onDelete, required this.onFinish, required this.onExtend});
  final Goal goal;
  final VoidCallback onDelete;
  final VoidCallback onFinish;
  final void Function(int) onExtend;

  @override
  Widget build(BuildContext context) {
    final TextEditingController goalExtensionInput = TextEditingController();

    deleteGoal() {
      api.deleteGoal(context, goal.goalId).then((response){
        if (response['status'] == true) {
        onDelete();
        } else {}
      });
    }

    finishGoal() {
      api.finishOrExtend(context, goal.goalId, true, 0).then((response) {
        if (response['status'] == true) {
        onFinish();
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error!"),
                content: const Text(
                    "An error occured while attempting to change the goal."),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Ok"))
                ],
              );
            });
        }
      });
    }

     extendGoal() {
      int extension = int.parse(goalExtensionInput.text);
      api.finishOrExtend(context, goal.goalId, false, (extension)).then((response) {
        if (response['status'] == true) {
        onExtend(extension);
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error!"),
                content: const Text(
                    "An error occured while attempting to change the goal."),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Ok"))
                ],
              );
            });
        }
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
              buildGoalWidgetHeader(context, deleteGoal, finishGoal, extendGoal, goalExtensionInput),
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

  Container buildGoalWidgetHeader(BuildContext context, void Function() deleteGoal, void Function() finishGoal, void Function() extendGoal, TextEditingController goalExtensionInput) {
    return Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                            TextSpan(
                                text: 'c/${goal.communityName}',
                                style: TextStyle(
                                  color: MediaQuery.of(context).platformBrightness == Brightness.dark
                                    ? AppThemes.darkTheme.primaryColor
                                    : AppThemes.lightTheme.primaryColor,
                                  fontSize: 20,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CommunityPage(
                                          communityName: goal.communityName,
                                        ),
                                      ),
                                    );
                                  }
                              ),
                            ]
                          ),
                        ),
                        Text(
                          getFormattedDate(goal.creationDate),
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  buildGoalStatusBadge(context, finishGoal, extendGoal, goalExtensionInput),
                  PopupMenuButton(itemBuilder: (context) {
                  return [
                    const PopupMenuItem<int>(
                      value: 0,
                      child: Text("Delete"),
                    ),
                    if(!goal.isFinished)
                      const PopupMenuItem<int>(
                        value: 1,
                        child: Text("Extend"),
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
                                deleteGoal();
                                Navigator.pop(context);
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        ),
                      );
                    }
                    if (value == 1) {
                       selectExtension(context, extendGoal, goalExtensionInput);
                    }
                  }),
                ],
              ),
            );
  }

  selectExtension(BuildContext context, void Function() extendGoal, TextEditingController goalExtensionInput) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Enter how many extra days you need:'),
        content: 
        
        TextField(
        controller: goalExtensionInput,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(hintText: "Ex: 5"),
        ),
        actions: <Widget>[
        TextButton(
          onPressed: () =>
          Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton( 
         onPressed: () {
          if ((goalExtensionInput.text != '') && (int.parse(goalExtensionInput.text.toString()) > 0)) {
              extendGoal();
              Navigator.pop(context);
          } else {
           showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
              content:
               const Text("Please enter a number greater than zero."),
               actions: [
                 TextButton(
                  onPressed: () {
                   Navigator.pop(context);
                   },
                  child: const Text("Ok"))
               ],
               );
             });
          }
         },
         child: const Text('Submit Extension'),
        ),
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
            progressColor: ((goal.completedCheckIns/goal.checkInGoal>=1 && !goal.isFinished)? Colors.red : Colors.green),
            circularStrokeCap: CircularStrokeCap.round,
            animation: true,
            percent: ((goal.completedCheckIns/goal.checkInGoal<=1)? goal.completedCheckIns/goal.checkInGoal : 1),
            center: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  ("${((goal.completedCheckIns/goal.checkInGoal) * 100).round()}%" ),
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
  
  buildGoalStatusBadge(BuildContext context, void Function() finishGoal, void Function() extendGoal, TextEditingController goalExtensionInput) {
    if((goal.completedCheckIns >= goal.checkInGoal) && !goal.isFinished){
      return IconButton(
        icon: const Icon(Icons.notification_important),
        color: Colors.red,
        tooltip: 'Finish or Extend Goal!',
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Goal is overdue!'),
              content: const Text('Would you like to finish or extend this goal?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () =>
                    Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                ),
                TextButton( 
                  onPressed: () {
                    Navigator.pop(context);
                    selectExtension(context, extendGoal, goalExtensionInput);
                  },
                  child: const Text('Extend'),
                ),
                TextButton( 
                  onPressed: () {
                    finishGoal();
                    Navigator.pop(context);
                  },
                  child: const Text('Mark as finished'),
                ),
              ],
            ),
          );
        },
      );
    } else if (goal.isFinished) {
      return IconButton(
        icon: const Icon(Icons.check_circle),
        color: Colors.green,
        tooltip: 'Goal is finished!',
        onPressed: () {},
      );
    } else {
      return const SizedBox();
    }
  }
}