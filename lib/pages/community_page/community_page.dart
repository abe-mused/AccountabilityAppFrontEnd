import 'package:flutter/material.dart';
import 'package:linear/model/community.dart';
import 'package:linear/model/post.dart';
import 'package:linear/pages/common_widgets/navbar.dart';
import 'package:linear/pages/post_widgets/create_post.dart';
import 'package:linear/pages/post_widgets/post_widget.dart';
import 'package:linear/util/apis.dart';
import 'package:linear/util/cognito/user.dart';
import 'package:linear/util/cognito/user_provider.dart';
import 'package:linear/util/date_formatter.dart';
import 'package:provider/provider.dart';

class CommunityPage extends StatefulWidget {
  CommunityPage({super.key, required this.communityName, required this.token});

  String communityName;
  String token;

  @override
  State<CommunityPage> createState() => CommunityPageState();
}

class CommunityPageState extends State<CommunityPage> {
  Community _community = Community(communityName: '', creationDate: 1, creator: '', members: []);
  List<dynamic> _post = [];

  @override
  void initState() {
    super.initState();
    doGetCommunity();
  }

  doGetCommunity() {
    final Future<Map<String, dynamic>> successfulMessage = getPostsForCommunity(widget.communityName, widget.token);
    successfulMessage.then((response) {
      if (response['status'] == true) {
        Community community = Community.fromJson(response['community']);
        print("ABE SAYS" + community.toString());
        setState(() {
          _community = community;
        });

        List<dynamic> post = (response['posts']);
        setState(() {
          _post = post;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      "c/${_community.communityName}",
                      style: const TextStyle(fontFamily: 'MonteSerrat', fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Created on ${getFormattedDate(_community.creationDate)}",
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      // ignore: unrelated_type_equality_checks
                      "${_community.members.length} members",
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            CreatePostWidget(token: widget.token, communityName: widget.communityName),
            const SizedBox(height: 10),
            // ignore: prefer_is_empty
            if ((_post.length) > 0) ...[
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _post.length,
                  itemBuilder: (context, index) {
                    return PostWidget(
                      post: Post(
                        communityName: _post[index]['community'],
                        postId: _post[index]['postId'],
                        creator: _post[index]['creator'],
                        creationDate: int.parse(_post[index]['creationDate']),
                        title: _post[index]['title'],
                        body: _post[index]['body'],
                      ),
                    );
                  },
                ),
              ),
            ] else ...[
              const Center(
                child: Text("No posts yet"),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: const LinearNavBar(),
    );
  }
}
