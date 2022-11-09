import 'package:flutter/material.dart';
import 'package:linear/util/apis.dart';
import 'package:linear/model/post.dart';

class CreatePostWidget extends StatefulWidget {
  CreatePostWidget(
      {super.key,
      required this.token,
      required this.communityName,
      required this.onSuccess});
  String token;
  String communityName;
  final Function onSuccess;

  @override
  State<CreatePostWidget> createState() => _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<CreatePostWidget> {
  TextEditingController postBodyInput = TextEditingController();
  TextEditingController postTitleInput = TextEditingController();

  Post _post = Post(
    communityName: '',
    postId: '',
    creator: '',
    creationDate: 0,
    title: '',
    body: '',
  );

  bool _isCreatingPost = false;

  doCreatePost() {
    setState(() {
      _isCreatingPost = true;
    });

    final Future<Map<String, dynamic>> responseMessage = createPost(
        postTitleInput.text,
        postBodyInput.text,
        widget.communityName,
        widget.token);

    responseMessage.then((response) {
      if (response['status'] == true) {
        Post post = Post(
            communityName: widget.communityName,
            postId: response['postId'],
            creator: '',
            creationDate: int.parse(response['creationDate']),
            title: postTitleInput.text,
            body: postBodyInput.text);

        setState(() {
          _post = post;
        });

        doCheckIn();
        postBodyInput.clear();
        postTitleInput.clear();
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Success!"),
                content: const Text("Post succesfully Created."),
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
                    "An error occured while attempting to create the post."),
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
        _isCreatingPost = false;
      });
    });
  }

  doCheckIn() {
    final Future<Map<String, dynamic>> responseMessage =
        checkIn(widget.communityName, widget.token);

    responseMessage.then((response) {
      if (response['status'] == true) {
        widget.onSuccess(_post);
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error!"),
                content: const Text(
                    "An error occured while attempting to check-in."),
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
    if (_isCreatingPost) {
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
              Text(
                "post something in c/${widget.communityName}!",
                style: const TextStyle(fontSize: 24),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: postTitleInput,
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
                    hintText: "post title",
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: postBodyInput,
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
                    hintText: "post body",
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (postTitleInput.text != '' && postBodyInput.text != '') {
                    doCreatePost();
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
                child: const Text("create post"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
