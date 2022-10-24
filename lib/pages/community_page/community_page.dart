import 'package:flutter/material.dart';
import 'package:linear/model/community.dart';
import 'package:linear/pages/common_widgets/navbar.dart';
import 'package:linear/util/cognito/user.dart';
import 'package:linear/util/cognito/user_provider.dart';
import 'package:provider/provider.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  State<CommunityPage> createState() => CommunityPageState();
}

class CommunityPageState extends State<CommunityPage> {
  @override
  Widget build(BuildContext context) {
    Community community = ModalRoute.of(context)!.settings.arguments as Community;

    User? user = Provider.of<UserProvider>(context).user;

    var token = user?.idToken ?? "INVALID_TOKEN";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Community"),
      ),
      body: SingleChildScrollView(
        // removes bottom overflow pixel error
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width,
              child: Card(
                margin: const EdgeInsets.only(top: 20.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      "c/${community.communityName}",
                      style: const TextStyle(fontFamily: 'MonteSerrat', fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "created on ${DateTime.fromMillisecondsSinceEpoch(community.creationDate)}",
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const LinearNavBar(),
    );
  }
}
