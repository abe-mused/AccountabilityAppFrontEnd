import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linear/constants/themeSettings.dart';
import 'package:linear/model/user.dart';
import 'package:linear/util/apis.dart';
import 'package:linear/util/cognito/user_provider.dart';
import 'package:linear/util/cognito/user.dart' as cognito_user;
import 'package:linear/pages/profile_page/follows_page/followers_list.dart';
import 'package:linear/pages/profile_page/follows_page/following_list.dart';

enum _Tab {followers, following}

// ignore: must_be_immutable
class ViewFollowsPage extends StatefulWidget {
  const ViewFollowsPage(
      {super.key, required this.token, required this.username, required this.user, required this.type});
  final String token;
  final String username;
  final User user;
  final String type;


  @override
  State<ViewFollowsPage> createState() => _ViewFollowsPageState();
}

class _ViewFollowsPageState extends State<ViewFollowsPage> {
  cognito_user.User? currentUser = UserProvider().user;

 
   _Tab _selectedTab = _Tab.followers;
   int timesCalled = 0;

  isViewingOwnProfile() {
    return currentUser!.username == widget.username;
  }

 @override
  Widget build(BuildContext context) {
      if(widget.type == "followers" && timesCalled == 0)
      { _selectedTab = _Tab.followers;
        timesCalled++;
      }
      if(widget.type == "following" && timesCalled == 0)
       { _selectedTab = _Tab.following;
        timesCalled++;
      }
      return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
        ),
        body:  Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
           SizedBox(height: 10),
           CupertinoSegmentedControl<_Tab>(
             children: {
              _Tab.followers: Text("${widget.user.followers?.length ?? 0} Followers", style: TextStyle(fontSize: 16)),
              _Tab.following: Text("${widget.user.following?.length ?? 0} Following", style: TextStyle(fontSize: 16)),
           },
          onValueChanged: (value) {
            setState(() {
              _selectedTab = value;
            });
          },
          groupValue: _selectedTab,
        ),
        SizedBox(height: 10),
        Builder(
          builder: (context) {
            switch (_selectedTab) {
              case _Tab.followers:
                return FollowersListWidget(token: widget.token, user: widget.user);
              case _Tab.following:
                return FollowingListWidget(token: widget.token, user: widget.user);
            }
          },
        ),
      ],
     ),
    );
  }
}