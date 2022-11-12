import 'package:flutter/material.dart';
import 'package:linear/pages/common_widgets/navbar.dart';
import 'package:linear/pages/home_page/home_page_content.dart';
import 'package:linear/util/cognito/user.dart';
import 'package:linear/util/cognito/user_provider.dart';
import 'package:linear/util/cognito/auth_util.dart' as authUtil;
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    authUtil.refreshTokenIfExpired().then((response) => {
          if (response['refreshed'] == true)
            {
              Provider.of<UserProvider>(context, listen: false).setUser(response['user']),
            }
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).user;

    if (user == null) {
      print("User is null in the homePage, redirecting to sign in");
      Navigator.pushReplacementNamed(context, '/login');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Linear Home Page!"),
        elevation: 0.1,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: HomePageContent(
          token: user!.idToken,
          username: user.username,
        ),
      ),
      bottomNavigationBar: const LinearNavBar(),
    );
  }
}
