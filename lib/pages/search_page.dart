import 'package:flutter/material.dart';
import 'package:linear/pages/common_widgets/navbar.dart';
import 'package:linear/pages/community_page.dart';
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

      if (response['status'] == true) {
          setState(() {
            _searchResults = response["searchResults"];
            _hasPerformedSearch = true;
            _isLoading = false;
          });
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Error!"),
              content: const Text("An unexpected error occurred while performing the search. Try searching again."),
              actions: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        _isLoading = false;
                        _hasPerformedSearch = false;
                      });
                      Navigator.pop(context);
                    },
                    child: const Text("Ok"))
              ],
            );
          },
        );
      }
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
        child: const Text("Can't find a community? Create a community here!"),
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
        if (_hasPerformedSearch && !_isLoading && _searchResults.isEmpty)
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(3.0),
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                  padding: const EdgeInsets.all(10.0),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "No results found",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  )),
            ),
          ),
    ]);
  }
}
