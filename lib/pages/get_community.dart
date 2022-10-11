import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:linear/constants/model/community.dart';

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
  Community _community = Community(communityName: "No Searches @#12", creator: "error 123@#", creationDate: 10000);

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
          Community community = await getCommunity(userInput.text, widget.token);
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
      if (_community.communityName == "Error @#12")
        const Text(
          "No Results Found, try creating a community!",
          style: TextStyle(fontSize: 24),
        ),
      if (_community.creator != "error 123@#")
        const Text(
          "Search Results:",
          style: TextStyle(fontSize: 24),
        ),
      if (_community.creator != "error 123@#") const SizedBox(height: 10),
      if (_community.creator != "error 123@#")
        Text(
          "name: ${_community.communityName}",
          style: const TextStyle(fontSize: 24),
        ),
      if (_community.creator != "error 123@#") const SizedBox(height: 5),
      if (_community.creator != "error 123@#")
        Text(
          "creator: ${_community.creator}",
          style: const TextStyle(fontSize: 24),
        ),
      if (_community.creator != "error 123@#") const SizedBox(height: 5),
      if (_community.creator != "error 123@#")
        Text(
          "creation date: ${DateTime.fromMillisecondsSinceEpoch(_community.creationDate)}",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
          ),
        ),
    ]);
  }
}
