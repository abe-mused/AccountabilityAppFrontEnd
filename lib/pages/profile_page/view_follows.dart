import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linear/model/user.dart';
import 'package:linear/pages/profile_page/profile_page.dart';

enum _Tab {followers, following}

// ignore: must_be_immutable
class ViewFollowsPage extends StatefulWidget {
  const ViewFollowsPage({super.key, required this.user, required this.type});
  final User user;
  final String type;


  @override
  State<ViewFollowsPage> createState() => _ViewFollowsPageState();
}

class _ViewFollowsPageState extends State<ViewFollowsPage> { 
   _Tab _selectedTab = _Tab.followers;

  @override
  void initState() {
    super.initState();

    _selectedTab = widget.type == "followers"? _Tab.followers : _Tab.following;
  }

 @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
        ),
        body:  Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
           const SizedBox(height: 10),
           CupertinoSegmentedControl<_Tab>(
            children: {
              _Tab.followers: Text("${widget.user.followers?.length ?? 0} Followers", style: const TextStyle(fontSize: 16)),
              _Tab.following: Text("${widget.user.following?.length ?? 0} Following", style: const TextStyle(fontSize: 16)),
            },
            onValueChanged: (value) {
              setState(() {
                _selectedTab = value;
              });
            },
            groupValue: _selectedTab,
        ),
        const SizedBox(height: 10),
        Builder(
          builder: (context) {
            switch (_selectedTab) {
              case _Tab.followers:
                return buildListOfUsersView(widget.user.followers);
              case _Tab.following:
                return buildListOfUsersView(widget.user.following);
            }
          },
        ),
      ],
     ),
    );
  }

  buildListOfUsersView(listOfUsers) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: listOfUsers.length,
      itemBuilder: (context, index) {
        return TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(
                    usernameToDisplay: listOfUsers[index]
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
                    "u/${listOfUsers[index]}",
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w800,
                    ),
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