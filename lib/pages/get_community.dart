import 'package:flutter/material.dart';
import 'package:linear/model/community.dart';
import 'package:linear/constants/apis.dart';
import 'package:linear/widgets/community_info_box.dart';

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
       Column(children: <Widget>[
          Container(
            decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.lightGreen,
            ),
            child: Column( 
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
              Text("c/${_community.communityName}", style: TextStyle(fontSize: 25)),
              Text("Created:${_community.creationDate}", style: TextStyle(fontSize: 25)),
              Text("Created by u/${_community.creator}", style: TextStyle(fontSize: 25)),
              ],
            ),
        )
         ],
        ),
    ]);
  }
}

