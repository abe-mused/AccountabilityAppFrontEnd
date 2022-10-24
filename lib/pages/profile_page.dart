import 'package:flutter/material.dart';
import 'package:linear/pages/common_widgets/logout_widget.dart';
import 'package:linear/pages/common_widgets/navbar.dart';
import 'package:linear/util/cognito/user.dart';
import 'package:linear/util/cognito/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:linear/pages/get_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  var _currentSelectedItem;

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        // setting option is added here on top of Profile page
        actions: <Widget>[
          PopupMenuButton(
              // add icon, by default "3 dot" icon
              // icon: Icon(Icons.book)
              itemBuilder: (context) {
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
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }
          }),
        ],
      ),
      body: Center(
          child: GetProfileWidget(token: user?.idToken ?? "INVALID TOKEN")),
      bottomNavigationBar: const LinearNavBar(),
    );
  }
}
