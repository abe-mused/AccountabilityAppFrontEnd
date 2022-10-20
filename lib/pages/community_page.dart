import 'package:flutter/material.dart';
import 'package:linear/main.dart';
import 'package:linear/pages/common_widgets/navbar.dart';
import 'package:linear/pages/home_page.dart';
import 'package:linear/pages/search_page.dart';
import 'package:linear/pages/profile_page.dart';
import 'package:linear/widgets/scrolling_post_view.dart';
import 'package:linear/widgets/community_info_box.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  State<CommunityPage> createState() => CommunityPageState();
}

class CommunityPageState extends State<CommunityPage> {
  String com = "communityName";
  String day = "dayCreated";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Community"),
      ),
      body: Center(),
      bottomNavigationBar: const LinearNavBar(),
    );
  }
}
