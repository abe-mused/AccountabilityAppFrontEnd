import 'package:flutter/material.dart';
import 'package:linear/util/apis.dart';
import 'package:linear/constants/themeSettings.dart';

class CreateCommentWidget extends StatefulWidget {
  CreateCommentWidget({super.key, required this.token, required this.postId});
  String token;
  String postId;

  @override
  State<CreateCommentWidget> createState() => _CreateCommentWidgetState();
}

class _CreateCommentWidgetState extends State<CreateCommentWidget> {
  TextEditingController commentBodyInput = TextEditingController();

  bool _isCreatingComment = false;

  doCreateComment() {
    setState(() {
      _isCreatingComment = true;
    });

    final Future<Map<String, dynamic>> successfulMessage =
        createComment(commentBodyInput.text, widget.postId, widget.token);

    successfulMessage.then((response) {
      if (response['status'] == true) {
        commentBodyInput.clear();
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Success!"),
                content: Text("Comment succesfully Created."),
              );
            });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error!"),
                content: const Text(
                    "An error occured while attempting to create the Comment."),
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
      setState(() {
        _isCreatingComment = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isCreatingComment) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
      width: MediaQuery.of(context).size.width * 0.9,
      child: Card(
        margin: const EdgeInsets.only(top: 20.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text(
                "create a comment!",
                style: TextStyle(fontSize: 24),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: commentBodyInput,
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
                    hintText: "comment body",
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (commentBodyInput.text != '') {
                    doCreateComment();
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: const Text("Please fill out all fields."),
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
                },
                child: const Text("create comment"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}