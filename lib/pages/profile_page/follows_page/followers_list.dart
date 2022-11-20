import 'package:flutter/material.dart';
import 'package:linear/model/user.dart';
import 'package:linear/pages/profile_page/profile_page.dart';
import 'package:linear/constants/themeSettings.dart';


class FollowersListWidget extends StatelessWidget {
  const FollowersListWidget({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: user.followers!.length,
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
                             builder: (context) => ProfilePage(
                                  username: user.followers![index]
                                ),
                            ),
                          );
                        },
                        child: Text(
                          "u/${user.followers![index]}",
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w800,
                          ),
                        )),
                        
                    if (user.following!.contains(user.followers![index]))
                      Icon(
                        Icons.group_rounded,
                        color: AppThemes.iconColor(context),
                        size: 30.0,
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
