import 'package:flutter/material.dart';
import 'package:linear/pages/common_widgets/navbar.dart';
import 'package:linear/pages/goal_page/get_goal_page.dart';

class GoalPage extends StatefulWidget {
  const GoalPage({super.key});

  @override
  State<GoalPage> createState() => GoalPageState();
}

class GoalPageState extends State<GoalPage> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Goals"),
          automaticallyImplyLeading: false,
        ),
        body: const Center(child: GetGoalsWidget()),
        bottomNavigationBar: const LinearNavBar(),
      );
  }
}