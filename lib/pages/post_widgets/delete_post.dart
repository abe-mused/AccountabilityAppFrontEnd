import 'package:flutter/material.dart';
import 'package:linear/constants/themeSettings.dart';
import 'package:linear/util/apis.dart';

class DeletePostWidget extends StatefulWidget {
  DeletePostWidget({super.key, required this.token, required this.postId});
  String token;
  String postId;

  @override
  State<DeletePostWidget> createState() => _DeletePostWidget();
}

class _DeletePostWidget extends State<DeletePostWidget> {
  TextEditingController postId = TextEditingController();

  bool _isDeletingPost = false;

  doDeletePost() {
    setState(() {
      _isDeletingPost = true;
    });

    final Future<Map<String, dynamic>> successfulMessage =
        deletePost(postId.text, widget.token);

    successfulMessage.then((response) {
      if (response['status'] == true) {
        postId.clear();
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Success!"),
                content: Text("Post succesfully Deleted."),
              );
            });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error!"),
                content: const Text(
                    "An error occured while attempting to delete the post."),
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
        _isDeletingPost = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
