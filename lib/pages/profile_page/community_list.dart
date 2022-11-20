import 'package:flutter/material.dart';
import 'package:linear/model/user.dart';
import 'package:linear/pages/community_page/community_page.dart';
import 'package:linear/constants/themeSettings.dart';
import 'package:linear/util/date_formatter.dart';

class CommunityListWidget extends StatelessWidget {
  CommunityListWidget(
      {super.key,
      required this.user,
      required this.communityLength,
      required this.currentEpoch});

  final User user;
  final int? communityLength;
  final int currentEpoch;

  List _streak = [];

  calculateStreak(index) {
    _streak.add(computeStreak(user.communities![index]['firstStreakDate'],
        user.communities![index]['lastStreakDate'], currentEpoch));
    return _streak[index];
  }

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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
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
                        child: Text(
                          "c/${user.communities![index]['communityName']}",
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w800,
                          ),
                        )),
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
                        if (user.username ==
                            user.communities![index]['creator']) ...[
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
      ),
    );
  }
}
