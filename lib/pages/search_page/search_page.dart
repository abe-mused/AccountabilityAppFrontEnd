import 'package:flutter/material.dart';
import 'package:linear/pages/common_widgets/navbar.dart';
import 'package:linear/pages/search_page/seach_results_widget.dart';
import 'package:linear/util/cognito/user.dart';
import 'package:linear/util/cognito/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:linear/util/cognito/auth_util.dart' as authUtil;

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
        elevation: 0.1,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        // removes bottom overflow pixel error
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 20),
            SearchResultWidget(token: user?.idToken ?? "INVALID TOKEN"),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/createCommunity');
              },
              child: const Text("Can't find a community? Create a community here!"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const LinearNavBar(),
    );
  }
}
