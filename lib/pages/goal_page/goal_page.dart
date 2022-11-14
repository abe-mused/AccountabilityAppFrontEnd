import 'package:flutter/material.dart';
import 'package:linear/model/goal.dart';
import 'package:linear/pages/common_widgets/navbar.dart';
import 'package:linear/pages/goal_widgets/create_goal_widget.dart';
import 'package:linear/pages/goal_widgets/goal_widget.dart';
import 'package:linear/pages/goal_page/get_goal_page.dart';
import 'package:linear/util/apis.dart';
import 'package:linear/util/cognito/user.dart';
import 'package:linear/util/cognito/user_provider.dart';
import 'package:linear/util/date_formatter.dart';
import 'package:provider/provider.dart';
import 'package:linear/constants/themeSettings.dart';


class GoalPage extends StatefulWidget {
  const GoalPage({super.key});

  @override
  State<GoalPage> createState() => GoalPageState();
}

class GoalPageState extends State<GoalPage> {
  List<dynamic> _goals = [];
  bool _isLoading = true;

  User? user = UserProvider().user;

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).user;
      return Scaffold(
        appBar: AppBar(
          title: const Text("Goals"),
          automaticallyImplyLeading: false,
        ),
        body: Center(child: GetGoalsWidget(token: user?.idToken ?? "INVALID TOKEN")),
        bottomNavigationBar: const LinearNavBar(),
      );
  }
}