// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:linear/pages/image_related_widgets/upload_image_widget.dart';
import 'package:linear/util/apis.dart';

class CreatePostWidget extends StatefulWidget {
  CreatePostWidget(
      {super.key,
      required this.communityName,
      required this.onSuccess});
  String communityName;
  final Function onSuccess;

  @override
  State<CreatePostWidget> createState() => _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<CreatePostWidget> {
  TextEditingController postBodyInput = TextEditingController();
  TextEditingController postTitleInput = TextEditingController();

  RegExp postBodyRegexValidation = RegExp(r"\w{5}\w{0,995}");
  RegExp postTitleRegexValidation = RegExp(r"\w{5}\w{0,251}");

  bool _isCreatingPost = false;

  bool shouldUploadImage() {
  if (postTitleRegexValidation.hasMatch(postTitleInput.text.trim().replaceAll(RegExp(r'\s+'), '')) &&
      postBodyRegexValidation.hasMatch(postBodyInput.text.trim().replaceAll(RegExp(r'\s+'), ''))) {
      setState(() {
        _isCreatingPost = true;
      });
      return true;
    }
    return false;
  }

  void onImageWidgetSubmit(String? url) {
    if (!postTitleRegexValidation.hasMatch(postTitleInput.text.trim().replaceAll(RegExp(r'\s+'), ''))) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content:
                const Text("Post title must be a minimum of 5 alphanumeric characters and a maximum of 256 characters."),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Ok"))
              ],
            );
          });
    } else if (!postBodyRegexValidation.hasMatch(postBodyInput.text.trim().replaceAll(RegExp(r'\s+'), ''))) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content:
              const Text("Post body must be a minimum of 5 alphanumeric characters and a maximum of 1000 characters."),
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
      doCreatePost(url);
    }
  }

  doCreatePost(String? url) {
    setState(() {
      _isCreatingPost = true;
    });

    final Future<Map<String, dynamic>> responseMessage = createPost(
        context,
        postTitleInput.text.trim().replaceAll(RegExp(r' \s+'), ' '),
        postBodyInput.text.trim().replaceAll(RegExp(r' \s+'), ' '),
        widget.communityName,
        url);

    responseMessage.then((response) {
      if (response['status'] == true) {
        postBodyInput.clear();
        postTitleInput.clear();
        widget.onSuccess();
        
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

  @override
  Widget build(BuildContext context) {
    if (_isCreatingPost) {
      return const Center(child: CircularProgressIndicator());
    }
    return 
    Container(
      margin: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.5,
      child: Card(
        margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20.0),
                child: Text(
                  "Create a post in c/${widget.communityName}!",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: postTitleInput,
                  maxLength: 256,
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
                    hintText: "post title...",
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: postBodyInput,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    maxLength: 1000,
                    onChanged: (value) {
                      setState(() {});
                    },
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      hintText: "body...",
                    ),
                  ),
                  ),
                ),
              UploadImageWidget(
                onLoading: shouldUploadImage,
                onSuccess: onImageWidgetSubmit,
                onCancel: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
