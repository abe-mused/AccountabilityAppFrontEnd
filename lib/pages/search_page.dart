import 'package:flutter/material.dart';
import 'package:linear/pages/common_widgets/navbar.dart';
import 'package:linear/pages/get_community.dart';
import 'package:linear/util/cognito/user.dart';
import 'package:linear/util/cognito/user_provider.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Community"),
        elevation: 0.1,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          const Center(
            child: Text(
              "Search Community",
              style: TextStyle(fontSize: 30),
            ),
          ),
          const SizedBox(height: 20),
          GetCommunityWidget(token: user?.idToken ?? "INVALID TOKEN"),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/createCommunity');
            },
            child: const Text("Can't find a community? Create a community here!"),
          ),
        ],
      ),
      bottomNavigationBar: const LinearNavBar(),
    );
  }
}
