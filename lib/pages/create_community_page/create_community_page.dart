import 'package:flutter/material.dart';
import 'package:linear/pages/common_widgets/navbar.dart';
import 'package:linear/pages/create_community_page/create_community.dart';

class CreateCommunityPage extends StatefulWidget {
  const CreateCommunityPage({Key? key}) : super(key: key);

  @override
  State<CreateCommunityPage> createState() => CreateCommunityPageState();
}

class CreateCommunityPageState extends State<CreateCommunityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Community"),
        elevation: 0.1,
      ),
      body: Column(
        children: const [
          SizedBox(height: 20),
          CreateCommunityWidget(),
        ],
      ),
      bottomNavigationBar: const LinearNavBar(),
    );
  }
}