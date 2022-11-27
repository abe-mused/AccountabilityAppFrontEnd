import 'package:flutter/material.dart';
import 'package:linear/pages/common_widgets/navbar.dart';
import 'package:linear/pages/community_page/community_page.dart';
import 'package:linear/pages/profile_page/profile_page.dart';
import 'package:linear/util/apis.dart' as api;

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  TextEditingController searchInput = TextEditingController();

  List<dynamic> _searchResults = [];
  bool _hasPerformedSearch = false;
  bool _isLoading = false;

  getSearchResults() {
    if(searchInput.text.isEmpty) {
      return;
    }
    
    setState(() {
      _isLoading = true;
      _hasPerformedSearch = true;
      _searchResults = [];
    });

    final Future<Map<String, dynamic>> apiResponse = api.getSearchResults(context, searchInput.text);
    apiResponse.then((response) {      
      searchInput.clear();

      setState(() {
        _searchResults = response['status'] == true? response["searchResults"] : [];
        _hasPerformedSearch = true;
        _isLoading = false;
      });
    });
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
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            buildSearchBar(),
            buildSearchResults(),
            const SizedBox(height: 10),
            buildCreateCommunityButton(),
          ],
        ),
      ),
      bottomNavigationBar: const LinearNavBar(),
    );
  }

  buildCreateCommunityButton() {
    return TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/createCommunity');
        },
        child: const Text("Can't find a community? Create one here!"),
      );
  }

  buildSearchBar(){
    return Container(
      margin: const EdgeInsets.all(10),
      child: TextFormField(
        controller: searchInput,
        style: const TextStyle(
          fontSize: 20,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          hintText: "Search for people or communities...",
          suffixIcon: IconButton(
            icon: Container(
                padding: const EdgeInsets.all(5),
                child: !_isLoading? 
                  const Icon(Icons.search)
                  : const CircularProgressIndicator(),
              ),
            onPressed: getSearchResults,
            style: IconButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }

  buildSearchResults(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _searchResults.length,
          itemBuilder: (context, index) {
            return Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(3.0),
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            if(_searchResults[index]["type"] == "COMMUNITY"){
                              return CommunityPage(communityName: _searchResults[index]["value"]);
                            } else {
                              return ProfilePage(usernameToDisplay: _searchResults[index]["value"]);
                            }
                          }
                        ),
                      );
                    },
                    child: Text(
                      "${(_searchResults[index]["type"] == "COMMUNITY")? "c/" : "u/"}${_searchResults[index]["value"]}",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        if (_hasPerformedSearch && !_isLoading && _searchResults.isEmpty)  ...[
          Container(
            margin: const EdgeInsets.fromLTRB(50, 0, 50, 0),
            child: Image.asset('assets/no_search_results.png'),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(40, 0, 40, 30),
            child: const Text(
              "We looked everywhere, and found nothing.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
        ] else if(!_hasPerformedSearch) ...[
          Container(
            margin: const EdgeInsets.fromLTRB(50, 10, 50, 0),
            child: Image.asset('assets/search_initial_screen.png'),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(40, 20, 40, 20),
            child: const Text(
              "Search for people to follow or communities to join!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ]
    ]);
  }
}
