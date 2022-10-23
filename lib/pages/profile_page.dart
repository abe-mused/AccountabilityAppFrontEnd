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
  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        // setting option is added here on top of Profile page
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () async {
              // added logout button
              // user is redirected to a page where he or she will have the option to logout
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LogoutButton()));
            },
          )
        ],
      ),
      body: Center(
          child: GetProfileWidget(token: user?.idToken ?? "INVALID TOKEN")),
      bottomNavigationBar: const LinearNavBar(),
    );
  }
}
