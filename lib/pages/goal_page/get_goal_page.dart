import 'package:flutter/material.dart';
import 'package:linear/util/apis.dart';
import 'package:linear/model/goal.dart';
import 'package:linear/pages/goal_widgets/goal_widget.dart';
class GetGoalsWidget extends StatefulWidget {
  const GetGoalsWidget({super.key});

  @override
  State<GetGoalsWidget> createState() => _GetGoalsWidgetState();
}

class _GetGoalsWidgetState extends State<GetGoalsWidget> {
  List<dynamic> _goals = [];

  bool _isLoading = true;
  bool isErrorFetchingGoals = false;

  int currentEpoch = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    doGetGoals();
  }

 doGetGoals() {
    final Future<Map<String, dynamic>> successfulMessage = getGoalsForGoalPage(context);
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
                        goal: Goal.fromJson(_goals[index]),
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