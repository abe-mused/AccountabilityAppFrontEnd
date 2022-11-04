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
        deletePost(widget.postId, widget.token);

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
    if (_isDeletingPost) {
      return const Center(child: CircularProgressIndicator());
    }
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
      width: MediaQuery.of(context).size.width * 0.9,
      child: Card(
        margin: const EdgeInsets.only(top: 20.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            PopupMenuButton(itemBuilder: (context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text("Delete"),
                ),
              ];
            }, onSelected: (value) {
              if (value == 0) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Delete'),
                    content: const Text(
                        'Are you sure you want to delete this post?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          DeletePostWidget(
                            postId: '',
                            token: widget.token,
                          );
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                );
              }
            }),
          ]),
        ),
      ),
    );
  }
}
