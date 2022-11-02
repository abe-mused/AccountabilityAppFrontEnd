import 'package:flutter/material.dart';
import 'package:linear/pages/common_widgets/navbar.dart';
import 'package:linear/util/cognito/user.dart';
import 'package:linear/util/cognito/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:linear/pages/profile_page/get_profile.dart';
import 'package:linear/util/cognito/user_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, this.username = ''}) : super(key: key);
  final String username;

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  logout() {
    final UserPreferences userPreferences = UserPreferences();
    userPreferences.clearPreferences();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).user;
    if (widget.username == '') {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            if (widget.username == '') ...[
              PopupMenuButton(itemBuilder: (context) {
                return [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text("Logout"),
                  ),
                ];
              }, onSelected: (value) {
                if (value == 0) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to log out?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            logout();
                          },
                          child: const Text('Ok'),
                        ),
                      ],
                    ),
                  );
                }
              }),
            ]
          ],
        ),
        body: Center(
            child: GetProfileWidget(
                token: user?.idToken ?? "INVALID TOKEN",
                username: user?.username ?? "INVALID USERNAME")),
        bottomNavigationBar: const LinearNavBar(),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          automaticallyImplyLeading: true,
        ),
        body: Center(
            child: GetProfileWidget(
                token: user?.idToken ?? "INVALID TOKEN",
                username: widget.username)),
        bottomNavigationBar: const LinearNavBar(),
      );
    }
  }
}
