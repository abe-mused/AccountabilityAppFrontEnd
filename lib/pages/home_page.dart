import 'package:flutter/material.dart';
import 'package:linear/pages/create_community.dart';
import 'package:linear/pages/get_community.dart';
import 'package:linear/util/cognito/user.dart';
import 'package:linear/util/cognito/user_preferences.dart';
import 'package:linear/util/cognito/user_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).user;

    if (user == null || user.username == null) {
      print("User is null in the homePage, redirecting to sign in");
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      print("User is not null in the homePage");
      print("name is ${user.username} email is ${user.email} name is ${user.name} token is ${user.idToken}");
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Linear Home Page!"),
        elevation: 0.1,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Center(
            child: Text(
              "Hello ${user?.name}",
              style: const TextStyle(fontSize: 30),
            ),
          ),
          const SizedBox(height: 20),
          CreateCommunityWidget(token: user?.idToken ?? "INVALID TOKEN"),
          const SizedBox(height: 20),
          GetCommunityWidget(token: user?.idToken ?? "INVALID TOKEN"),
        ],
      ),
    );
  }
}
