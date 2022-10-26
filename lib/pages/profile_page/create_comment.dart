import 'package:flutter/material.dart';
import 'package:linear/util/apis.dart';

class CreateCommenttWidget extends StatefulWidget {
  CreateCommenttWidget({super.key, required this.token, required this.postId});
  String token;
  String postId;

  @override
  State<CreateCommenttWidget> createState() => _CreateCommentWidgetState();
}

class _CreateCommentWidgetState extends State<CreateCommenttWidget> {
  TextEditingController commentBodyInput = TextEditingController();
  TextEditingController postIdInput = TextEditingController();

  doCreateComment() {
    final Future<Map<String, dynamic>> successfulMessage =
        createComment(postIdInput.text, commentBodyInput.text, widget.postId);

    successfulMessage.then((response) {
      if (response['status'] == true) {
        commentBodyInput.clear();
        postIdInput.clear();
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Success!"),
                content: Text("Comment has been published."),
              );
            });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error!"),
                content: const Text("Invalid comment, please try again."),
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
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
      width: MediaQuery.of(context).size.width * 0.9,
      child: Card(
        margin: const EdgeInsets.only(top: 20.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                "${widget.postId}!",
                style: const TextStyle(fontSize: 24),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: postIdInput,
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
                  ),
                ),
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
                    focusColor: Colors.white,
                    fillColor: Colors.grey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
              TextButton(
                  onPressed: () async {
                    if (postIdInput.text != '' && commentBodyInput.text != '') {
                      doCreateComment();
                    }
                  },
                  child: const Text("Post")),
            ],
          ),
        ),
      ),
    );
  }
}
