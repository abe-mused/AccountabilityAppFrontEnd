import 'package:flutter/material.dart';
import 'package:linear/model/user.dart';
import 'package:linear/pages/community_page/community_page.dart';
import 'package:linear/constants/themeSettings.dart';

class CommunityListWidget extends StatelessWidget {
  const CommunityListWidget(
      {super.key,
      required this.user,
      required this.communityLength,
      required this.token,
      required this.currentEpoch});

  final User user;
  final int? communityLength;
  final String token;
  final int currentEpoch;

  computeStreak(firstStreakEpoch, lastStreakEpoch) {
    firstStreakEpoch = int.parse(firstStreakEpoch);
    lastStreakEpoch = int.parse(lastStreakEpoch);
    if (currentEpoch - 86400000 < lastStreakEpoch) {
      int streak = (lastStreakEpoch - firstStreakEpoch) ~/ 86400000;
      print('streak: $streak');
      return streak;
    } else {
      return 0;
    }
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
                                communityName: user.communities![index][0]
                                    ['communityName'],
                                token: token,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "c/${user.communities![index][0]['communityName']}",
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w800,
                          ),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (computeStreak(
                                user.communities![index][1]
                                    ['first_streak_date'],
                                user.communities![index][1]
                                    ['last_streak_date']) >=
                            3) ...[
                          Text(
                            "${computeStreak(user.communities![index][1]['first_streak_date'], user.communities![index][1]['last_streak_date'])}",
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
                            user.communities![index][1]['creator']) ...[
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
