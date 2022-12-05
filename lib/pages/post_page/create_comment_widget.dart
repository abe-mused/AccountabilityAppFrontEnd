import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linear/util/apis.dart';

// ignore: must_be_immutable
class CreateCommentWidget extends StatefulWidget {
  CreateCommentWidget({super.key, required this.postId, required this.addComment});
  String postId;
  Function addComment;

  @override
  State<CreateCommentWidget> createState() => _CreateCommentWidgetState();
}

class _CreateCommentWidgetState extends State<CreateCommentWidget> {
  TextEditingController commentBodyInput = TextEditingController();
  RegExp commentBodyRegexValidation = RegExp(r"\w{5}\w{0,251}");

  bool _isCreatingComment = false;
  Map<String, dynamic> _newComment = {};

  doCreateComment() {
    setState(() {
      _isCreatingComment = true;
    });

    createComment(
      context,
      commentBodyInput.text.trim().replaceAll(RegExp(r' \s+'), ' '),
      widget.postId)
    .then((response) {
      if (response['status'] == true) {
        setState(() {
          _newComment = response['comment'];
        });
        widget.addComment(_newComment);
        commentBodyInput.clear();
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Success!"),
                content: const Text("Comment succesfully Created."),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Ok"))
                ],
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
                "Add a Comment!",
                style: TextStyle(fontSize: 24),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: Expanded(
                  child: TextFormField(
                    controller: commentBodyInput,
                    maxLength: 256,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(256),
                    ],
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
              ),
              ElevatedButton(
                onPressed: () async {
                  if(!commentBodyRegexValidation.hasMatch(commentBodyInput.text.trim().replaceAll(RegExp(r'\s+'), ''))){
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Invalid input!"),
                          content: const Text(
                              "Comment body must be at least 5 alphanumeric characters long and no more than 256 characters long."),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Ok"))
                          ],
                        );
                      });
                  } else {
                    doCreateComment();
                  }
                },
                child: const Text("Add a Comment"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
