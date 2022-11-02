import 'package:flutter/material.dart';
import 'package:linear/model/community.dart';
import 'package:linear/model/user.dart';
import 'package:linear/pages/community_page/community_page.dart';
import 'package:linear/pages/profile_page/profile_page.dart';
import 'package:linear/util/apis.dart' as API;
import 'package:linear/util/date_formatter.dart';
import 'package:linear/constants/themeSettings.dart';

// ignore: must_be_immutable
class SearchResultWidget extends StatefulWidget {
  SearchResultWidget({super.key, required this.token});
  String token;

  @override
  State<SearchResultWidget> createState() => _SearchResultWidgetState();
}

class _SearchResultWidgetState extends State<SearchResultWidget> {
  TextEditingController userInput = TextEditingController();
  Community _community =
      Community(communityName: '', creationDate: 1, creator: '', members: []);
  User _user = User(username: '', name: '', communities: []);

  getSearchResults() {
    _community =
        Community(communityName: '', creationDate: 1, creator: '', members: []);
    _user = User(username: '', name: '', communities: []);
    final Future<Map<String, dynamic>> apiResponse =
        API.getSearchResults(userInput.text, widget.token);
    apiResponse.then((response) {
      if (response['status'] == true) {
        if (!response['searchResults']['communities'].isEmpty) {
          print("COMMUNIT IS: " +
              response['searchResults']['communities'][0].toString());

          Community community =
              Community.fromJson(response['searchResults']['communities'][0]);
          print("objectobjectobject");
          setState(() {
            _community = community;
          });
        }
        if (!response['searchResults']['users'].isEmpty) {
          User user = User.fromJson(response['searchResults']['users'][0]);
          setState(() {
            _user = user;
          });
        }
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error!"),
                content: Text(
                    "No results found. Try creating the community ${userInput.text}."),
                actions: [
                  TextButton(
                      onPressed: () {
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
    return Column(children: [
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
                getSearchResults();
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
          ),
        ),
      ),
      if (_community.communityName != '')
        const Text(
          "communities:",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      if (_community.communityName != '')
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width,
          child: Card(
            margin: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10),
                Text(
                  "c/${_community.communityName}",
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  "Created on ${getFormattedDate(_community.creationDate)}",
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  // ignore: unrelated_type_equality_checks
                  "${_community.members.length} members",
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
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
                  child: const Text("visit community"),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      const SizedBox(height: 20),
      if (_user.username != '')
        const Text(
          "Users:",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      if (_user.username != '')
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Card(
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
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      const SizedBox(height: 10),
    ]);
  }
}
