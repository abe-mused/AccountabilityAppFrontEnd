import 'package:flutter/material.dart';
import 'package:linear/model/community.dart';
import 'package:linear/pages/community_page/community_page.dart';
import 'package:linear/util/apis.dart';
import 'package:linear/util/date_formatter.dart';

// ignore: must_be_immutable
class GetCommunityWidget extends StatefulWidget {
  GetCommunityWidget({super.key, required this.token});
  String token;

  @override
  State<GetCommunityWidget> createState() => _GetCommunityWidgetState();
}

class _GetCommunityWidgetState extends State<GetCommunityWidget> {
  TextEditingController userInput = TextEditingController();
  Community _community = Community(communityName: '', creationDate: 1, creator: '', members: []);

  doGetCommunity() {
    final Future<Map<String, dynamic>> successfulMessage = getCommunity(userInput.text, widget.token);
    successfulMessage.then((response) {
      if (response['status'] == true) {
        Community community = Community.fromJson(response['community']);
        setState(() {
          _community = community;
        });
      } else {
        Community community = Community(communityName: '', creationDate: 1, creator: '', members: []);
        setState(() {
          _community = community;
        });
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error!"),
                content: Text("No results found. Try creating the community ${userInput.text}."),
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
            focusColor: Colors.white,
            fillColor: Colors.grey,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            hintText: "Search for a Community:",
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                //add name to db using the new_community_name variable
                doGetCommunity();
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
          ),
        ),
      ),
      if (_community.communityName != '')
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width,
          child: Card(
            margin: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: <Widget>[
                Text(
                  "c/${_community.communityName}",
                  style: const TextStyle(fontFamily: 'MonteSerrat', fontSize: 24, fontWeight: FontWeight.bold),
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
                TextButton(
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
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text("visit community"),
                ),
              ],
            ),
          ),
        ),
    ]);
  }
}
