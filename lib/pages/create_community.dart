import 'package:flutter/material.dart';

import 'package:linear/constants/apis.dart';

// ignore: must_be_immutable
class CreateCommunityWidget extends StatefulWidget {
  CreateCommunityWidget({super.key, required this.token});
  String token;

  @override
  State<CreateCommunityWidget> createState() => _CreateCommunityWidgetState();
}

class _CreateCommunityWidgetState extends State<CreateCommunityWidget> {
  TextEditingController userInput = TextEditingController();
  bool _success = false;
  bool _error = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Center(
        child: Text(
          "Create a Community:",
          style: TextStyle(fontSize: 24),
        ),
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
            focusColor: Colors.white,
            fillColor: Colors.grey,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            hintText: "Enter the name of your community",
          ),
        ),
      ),
      TextButton(
        onPressed: () async {
          //add name to db using the new_community_name variable
          bool tempSuccess = await postCommunity(userInput.text, widget.token);

          print("this should be after");
          setState(() {
            _success = tempSuccess;
            _error = !tempSuccess;
          });
        },
        style: TextButton.styleFrom(
          primary: Colors.white,
          backgroundColor: Colors.blue,
          onSurface: Colors.grey,
        ),
        child: Text(_success
            ? "Success!"
            : _error
                ? "Error!"
                : "Create Community"),
      ),
    ]);
  }
}
