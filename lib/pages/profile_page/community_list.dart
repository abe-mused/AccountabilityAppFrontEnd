import 'package:flutter/material.dart';
import 'package:linear/model/user.dart';
import 'package:linear/pages/community_page.dart';
import 'package:linear/constants/themeSettings.dart';
import 'package:linear/util/date_formatter.dart';

class CommunityListWidget extends StatelessWidget {
  CommunityListWidget(
      {super.key,
      required this.user,
      required this.communityLength});

  final User user;
  final int? communityLength;
  final ScrollController _scrollController = ScrollController();

  final List _streak = [];

  calculateStreak(index) {
    _streak.add(computeStreak(user.communities![index]['firstStreakDate'],
        user.communities![index]['lastStreakDate']));
    return _streak[index];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (user.communities!.isEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
            child: Text('${user.username} is not part of a community. Yet...')
          ),
        ] else ...[
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: buildListOfCommunities(
                user.communities!.length <= 3 ?
                  user.communities!.length 
                  : 3
              ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('All Communities'),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15.0),
                        ),
                        content: SizedBox(
                          height: 400,
                          width: 300,
                          child: Scrollbar(
                            thumbVisibility: false,
                            controller: _scrollController,
                            child: buildListOfCommunities(user.communities!.length),
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Okay'))
                        ],
                      ),
                    );
                  },
                  child: const Text(
                    "see all communities",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ]
      ]
    );
  }

  buildListOfCommunities(int numberOfItems) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: numberOfItems,
      itemBuilder: (context, index) {
        return TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CommunityPage(
                  communityName: user.communities![index]['communityName'],
                ),
              ),
            );
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "c/${user.communities![index]['communityName']}",
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (calculateStreak(index) >= 3) ...[
                        Text(
                          "${_streak[index]}",
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Icon(
                          Icons.local_fire_department,
                          color: AppThemes.iconColor(context),
                          size: 30.0,
                        ),
                      ],
                      if (user.username == user.communities![index]['creator']) ...[
                        Icon(
                          Icons.admin_panel_settings,
                          color: AppThemes.iconColor(context),
                          size: 30.0,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
