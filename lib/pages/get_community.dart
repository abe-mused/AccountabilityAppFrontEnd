import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:linear/model/community.dart';

// ignore: must_be_immutable
class GetCommunityWidget extends StatefulWidget {
  GetCommunityWidget({super.key, required this.token});
  String token;

  @override
  State<GetCommunityWidget> createState() => _GetCommunityWidgetState();
}

class _GetCommunityWidgetState extends State<GetCommunityWidget> {
  TextEditingController userInput = TextEditingController();
  Community _community = Community(communityName: "basketball", creator: "abe", creationDate: 123);

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
          Community community = await postCommunity(userInput.text, widget.token);

          print("this should be after");
          setState(() {
            _community = community;
          });
        },
        style: TextButton.styleFrom(
          primary: Colors.white,
          backgroundColor: Colors.blue,
          onSurface: Colors.grey,
        ),
        child: const Text("Search"),
      ),
      if (_community.communityName != "basketball")
        const Text(
          "Search Results:",
          style: TextStyle(fontSize: 24),
        ),
      if (_community.communityName != "basketball") const SizedBox(height: 10),
      if (_community.communityName != "basketball")
        Text(
          "name: ${_community.communityName}",
          style: const TextStyle(fontSize: 24),
        ),
      if (_community.communityName != "basketball") const SizedBox(height: 5),
      if (_community.communityName != "basketball")
        Text(
          "creator: ${_community.creator}",
          style: const TextStyle(fontSize: 24),
        ),
      if (_community.communityName != "basketball") const SizedBox(height: 5),
      if (_community.communityName != "basketball")
        Text(
          "creation date: ${DateTime.fromMillisecondsSinceEpoch(_community.creationDate)}",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
          ),
        ),
    ]);
  }

  Future<Community> postCommunity(String text, String token) async {
    developer.log("getting community with name $text and token '$token'");

    return await http.get(
      Uri.parse('https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/community?communityName=$text'),
      headers: {
        "Authorization": token,
        "Content-Type": "application/json",
      },
    ).then(
      (response) {
        developer.log("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);
          var community = jsonResponse['community'];
          if (community != null && community[0] != null) {
            print("Not null");
          } else if (community != null) {
            print("Just empty");
          } else {
            print("Something else");
          }
          print("Success!: ${community[0]}");
          return Community.fromJson(community[0]);
        } else {
          return Community(communityName: 'basketball', creationDate: 123, creator: 'abe');
        }
      },
    );

    // return false;
  }
}
