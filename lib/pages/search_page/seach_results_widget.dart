import 'package:flutter/material.dart';
import 'package:linear/model/community.dart';
import 'package:linear/model/user.dart';
import 'package:linear/pages/community_page/community_page.dart';
import 'package:linear/pages/profile_page/profile_page.dart';
import 'package:linear/util/apis.dart' as API;

// ignore: must_be_immutable
class SearchResultWidget extends StatefulWidget {
  SearchResultWidget({super.key, required this.token});
  String token;

  @override
  State<SearchResultWidget> createState() => _SearchResultWidgetState();
}

class _SearchResultWidgetState extends State<SearchResultWidget> {
  TextEditingController userInput = TextEditingController();
  Community _community = Community(communityName: '', creationDate: 1, creator: '', members: [], checkIns: []);
  User _user = User(username: '', name: '', communities: [], followers: [], following: []);
  bool _isLoading = false;
  bool _initialize = true;

  getSearchResults() {
    _community = Community(communityName: '', creationDate: 1, creator: '', members: [], checkIns: []);
    _user = User(username: '', name: '', communities: [], followers: [], following: []);
    final Future<Map<String, dynamic>> apiResponse = API.getSearchResults(context, userInput.text);
    apiResponse.then((response) {
      if (response['status'] == true) {
        if (!response['searchResults']['communities'].isEmpty) {
          Community community = Community.fromJson(response['searchResults']['communities'][0]);
          setState(() {
            _community = community;
            _isLoading = false;
            _initialize = false;
          });
        }
        if (!response['searchResults']['users'].isEmpty) {
          User user = User.fromJson(response['searchResults']['users'][0]);
          setState(() {
            _user = user;
            _isLoading = false;
            _initialize = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            _initialize = false;
          });
        }
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error!"),
                content: const Text("No results found. Try searching again."),
                actions: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _isLoading = false;
                          _initialize = false;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("Ok"))
                ],
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Align(
        alignment: Alignment.centerLeft,
      ),
      Container(
        margin: const EdgeInsets.all(10),
        child: TextFormField(
          controller: userInput,
          style: const TextStyle(
            fontSize: 20,
          ),
          onChanged: (value) {
            setState(() {});
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            hintText: "Search for something...",
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                  _initialize = false;
                });
                getSearchResults();
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
          ),
        ),
      ),
      if (_isLoading)
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(3.0),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
          ),
        ),
      if (_community.communityName == '' && _user.username == '' && !_isLoading && !_initialize)
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
      if (_community.communityName != '')
        Container(
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
                      builder: (context) => CommunityPage(
                        communityName: _community.communityName,
                        token: widget.token,
                      ),
                    ),
                  );
                },
                child: Text(
                  "c/${_community.communityName}",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      if (_user.username != '')
        Container(
          padding: const EdgeInsets.all(3.0),
          width: MediaQuery.of(context).size.width,
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        username: _user.username,
                      ),
                    ),
                  );
                },
                child: Text(
                  "u/${_user.username}",
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ),
      const SizedBox(height: 10),
    ]);
  }
}
