import 'package:flutter/material.dart';
import 'package:linear/pages/common_widgets/navbar.dart';
import 'package:linear/pages/search_page/seach_results_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            SearchResultWidget(),
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
