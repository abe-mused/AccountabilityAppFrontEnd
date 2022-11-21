import 'package:flutter/material.dart';
import 'package:linear/model/goal.dart';
import 'package:linear/pages/common_widgets/navbar.dart';
import 'package:linear/pages/common_widgets/goal_widget.dart';
import 'package:linear/util/apis.dart' as api;

class GoalPage extends StatefulWidget {
  const GoalPage({super.key});

  @override
  State<GoalPage> createState() => GoalPageState();
}

class GoalPageState extends State<GoalPage> {
  List<dynamic> _goals = [];

  bool _isLoading = true;
  bool _isErrorFetchingGoals = false;

  @override
  void initState() {
    super.initState();
    fetchGoals();
  }

  fetchGoals() {
    final Future<Map<String, dynamic>> successfulMessage = api.getGoalsForGoalPage(context);
    successfulMessage.then((response) {
      if (response['status'] == true) {
        setState(() {
          _goals = response['goals'];
          _isLoading = false;
          _isErrorFetchingGoals = false;
        });
      } else {
        setState(() {
          _goals = [];
          _isLoading = false;
          _isErrorFetchingGoals = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Goals"),
          automaticallyImplyLeading: false,
        ),
        body: Center(
            child: _isLoading?
              const CircularProgressIndicator()
              : _isErrorFetchingGoals?
                const Text(
                  "We ran into an error trying to obtain the goals. \nPlease try again later.",
                  textAlign: TextAlign.center,
                )
                : buildGoalsList(),
              
          ),
        bottomNavigationBar: const LinearNavBar(),
      );
  }
  
  buildGoalsList() {
    return RefreshIndicator(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [             
              ListView.builder(
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
              if (_goals.isEmpty) ...[
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
          fetchGoals();
        },
      );
  }
}