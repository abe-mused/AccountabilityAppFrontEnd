import 'package:flutter/material.dart';
import 'package:linear/model/user.dart';
import 'package:linear/util/apis.dart';
import 'package:linear/util/cognito/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:linear/pages/goal_widgets/create_goal_widget.dart';
import 'package:linear/util/cognito/user.dart';
import 'package:linear/util/cognito/user_provider.dart';
import 'package:linear/model/goal.dart';
import 'package:linear/pages/goal_widgets/goal_widget.dart';
import 'package:linear/util/cognito/user.dart' as cognito_user;
import 'package:linear/util/date_formatter.dart';

// ignore: must_be_immutable
class GetGoalsWidget extends StatefulWidget {
  const GetGoalsWidget(
      {super.key, required this.token});
  final String token;

  @override
  State<GetGoalsWidget> createState() => _GetGoalsWidgetState();
}

class _GetGoalsWidgetState extends State<GetGoalsWidget> {
  cognito_user.User? currentUser = UserProvider().user;
  List<dynamic> _goals = [];

  final ScrollController _scrollController = ScrollController();

  bool _isLoading = true;
  bool isErrorFetchingGoals = false;

  int currentEpoch = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    doGetGoals();
  }

 doGetGoals() {
    final Future<Map<String, dynamic>> successfulMessage = getGoalsForGoalPage(widget.token);
    successfulMessage.then((response) {
      if (response['status'] == true) {
        List<dynamic> goals = (response['goals']);
        setState(() {
          _goals = goals;
        });
       
        setState(() {
          _isLoading = false;
        });
      }
      else {
        setState(() {
          _isLoading = false;
          isErrorFetchingGoals = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    if (_isLoading == false && isErrorFetchingGoals == false) {
      return Scaffold(
         body: RefreshIndicator(
        child: SingleChildScrollView(
          // removes bottom overflow pixel error
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // ignore: prefer_is_empty 
              
              if ((_goals.length) > 0) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _goals.length,
                    itemBuilder: (context, index) {
                      return GoalWidget(
                        token: widget.token,
                        goal: Goal(
                          communityName: _goals[index]['community'],
                          goalId: _goals[index]['goalId'],
                          creator: _goals[index]['creator'],
                          creationDate: int.parse(_goals[index]['creationDate']),
                          checkInGoal: _goals[index]['checkInGoal'],
                          goalBody: _goals[index]['goalBody'],
                          completedCheckIns: _goals[index]['completedCheckIns'],
                        ),
                        onDelete: () {  
                          setState(() {
                          _goals.removeAt(index);
                        });
                        }, 
                      );
                    },
                  ),
                ),
              ] else ...[
                const Center(
                  child: Text("No goals yet"),
                ),
              ],
            ],
          ),
        ),
        onRefresh: () async {
          setState(() {
            _isLoading = true;
          });
          doGetGoals();
        },
      ),
      );
    } else if (_isLoading == false && isErrorFetchingGoals == true) {
      return const Scaffold(
        body: Center(
          child: Text(
            "We ran into an error trying to obtain the goals. \nPlease try again later.",
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}