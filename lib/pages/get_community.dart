import 'package:flutter/material.dart';
import 'package:linear/model/community.dart';
import 'package:linear/constants/apis.dart';

// ignore: must_be_immutable
class GetCommunityWidget extends StatefulWidget {
  GetCommunityWidget({super.key, required this.token});
  String token;

  @override
  State<GetCommunityWidget> createState() => _GetCommunityWidgetState();
}

class _GetCommunityWidgetState extends State<GetCommunityWidget> {
  TextEditingController userInput = TextEditingController();
  Community _community =
      Community(communityName: '', creationDate: 1, creator: '');

  doGetCommunity() {
    final Future<Map<String, dynamic>> successfulMessage =
        getCommunity(userInput.text, widget.token);
    successfulMessage.then((response) {
      if (response['status'] == true) {
        Community community = Community.fromJson(response['community']);
        setState(() {
          _community = community;
        });
      } else {
        Community community =
            Community(communityName: '', creationDate: 1, creator: '');
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
          ),
        ),
      ),
      TextButton(
        onPressed: () async {
          //add name to db using the new_community_name variable
          doGetCommunity();
        },
        style: TextButton.styleFrom(
          primary: Colors.white,
          backgroundColor: Colors.blue,
          onSurface: Colors.grey,
        ),
        child: const Text("Search"),
      ),
      if (_community.communityName != '')
        Column(
          children: [
            const Text(
              "Search Results:",
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Name: ${_community.communityName}",
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Creator: ${_community.creator}",
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Creation Date: ${_community.creationDate}",
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
    ]);
  }
}
