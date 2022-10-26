import 'package:flutter/material.dart';
import 'package:linear/model/user.dart';
import 'package:linear/pages/community_page/community_page.dart';

class CommunityListWidget extends StatelessWidget {
  const CommunityListWidget(
      {super.key, required this.user, required this.communityLength, required this.token});

  final User user;
  final int ?communityLength;
  final String token;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: communityLength,
        itemBuilder: (context, index) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Card(
              margin: const EdgeInsets.only(top: 10.0),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommunityPage(
                            communityName: user.communities![index][0]['communityName'],
                            token: token,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "c/${user.communities![index][0]['communityName']}",
                      style: const TextStyle(
                          fontFamily: 'MonteSerrat', fontSize: 16),
                      textAlign: TextAlign.left,
                    )),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
