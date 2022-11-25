import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linear/model/post.dart';
import 'package:linear/pages/common_widgets/navbar.dart';
import 'package:linear/pages/common_widgets/post_widget.dart';
import 'package:linear/pages/profile_page/profile_page.dart';
import 'package:linear/util/apis.dart';
import 'package:linear/util/date_formatter.dart';
import 'package:linear/pages/common_widgets/user_icon.dart';
import 'package:linear/util/cognito/auth_util.dart' as auth_util;


class PostPage extends StatefulWidget {
  PostPage({super.key, required this.postId, required this.route, required this.addComment});

  String postId;
  Widget route;
  Function addComment;

  @override
  State<PostPage> createState() => PostPageState();
}

class PostPageState extends State<PostPage> {
  Post _post = Post(
      title: '',
      body: '',
      communityName: '',
      postId: '',
      creationDate: 1,
      creator: '',
      likes: [],
      commentCount: 0);

  List<dynamic> _comments = [];
  String? _currentUsername;
  bool _isloading = true;

  TextEditingController commentBodyInput = TextEditingController();
  bool _isCreatingComment = false;
  Map<String, dynamic> _newComment = {};

  @override
  void initState() {
    super.initState();
    
    auth_util.getUserName().then((userName) {
      setState(() {
        _currentUsername = userName;
      });
    });

    doGetPost();
  }

  deletePost(context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => widget.route));
  }

    doCreateComment() {
    setState(() {
      _isCreatingComment = true;
    });

    final Future<Map<String, dynamic>> successfulMessage =
        createComment(context, commentBodyInput.text, widget.postId);
    successfulMessage.then((response) {
      if (response['status'] == true) {
        setState(() {
          _newComment = response['comment'];
        });
        // addComment
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

  doDeleteComment(passIndex) {
    final Future<Map<String, dynamic>> responseMessage = 
        deleteComment(context, widget.postId, _comments[passIndex]['commentId']);
    responseMessage.then((response) {
      if (response['status'] == true) {
        _post.commentCount -= 1;
        setState(() {
          _comments.removeAt(passIndex);
          _post = _post; 
        });
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Success!"),
                content: const Text("Comment succesfully deleted."),
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
                    "An error occurred while deleting the comment, please try again."),
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

  doGetPost() {
    final Future<Map<String, dynamic>> responseMessage =
        getPostWithComments(context, widget.postId);
    responseMessage.then((response) {
      if (response['status'] == true) {
        response['post']['creationDate'] =
            int.parse(response['post']['creationDate']);
        Post post = Post.fromJson(response['post']);

        setState(() {
          _post = post;
        });

        List<dynamic> comments = (response['comments']);
        setState(() {
          _comments = comments;
          _isloading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isloading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Post"),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
        bottomNavigationBar: const LinearNavBar(),
      );
    }
    if (_isCreatingComment) {
      return const Center(
        child: CircularProgressIndicator()
        );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post"),
      ),
      body: RefreshIndicator(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.height,
                child: PostWidget(
                  isPostPage: true,
                  onLike: (likes) => setState(() {
                    _post.likes = likes;
                  }),
                  post: _post,
                  onDelete: () {
                    deletePost(context);
                  },
                  route: widget.route, 
                  // addComment
                  addComment: () { 
                    setState(() {
                      doCreateComment();
                    });
                   },
                ),
              ),
              const SizedBox(height: 10),
              Column(
              children: [
                const Text(
                  "Add a Comment!",
                  style: TextStyle(fontSize: 24),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: commentBodyInput,
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
                      hintText: "Comment Body",
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
                  child: const Text("Add a Comment"),
                ),
              ],
            ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Card(
                      margin: const EdgeInsets.only(top: 20.0),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: RawMaterialButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ProfilePage(
                                                usernameToDisplay: _comments[index]['creator'],
                                              ),
                                            ),
                                          );
                                        },
                                        child: _comments[index]["creatorImageUrl"] == null?
                                            UserIcon(radius: 45, username: _comments[index]["creator"])
                                            : ClipRRect(
                                                borderRadius: BorderRadius.circular(45),
                                                child: SizedBox.fromSize(
                                                  size: const Size.fromRadius(45),
                                                  child: Image.network(_comments[index]["creatorImageUrl"], fit: BoxFit.cover),
                                                ),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "u/${_comments[index]['creator']}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22),
                                          ),
                                          Text(
                                            getFormattedDate(int.parse(
                                                _comments[index]['creationDate']
                                                    .toString())),
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (_comments[index]['creator'] == _currentUsername) ...[
                                      PopupMenuButton(
                                        itemBuilder: (context) {
                                          return [
                                            const PopupMenuItem<int>(
                                              value: 0,
                                              child: Text("Delete"),
                                            ),
                                          ];
                                        },
                                        onSelected: (value) {
                                          if (value == 0) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                title: const Text('Delete'),
                                                content: const Text(
                                                    'Are you sure you want to delete this comment?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'Cancel'),
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      doDeleteComment(index);
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Yes'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        }
                                      ),
                                    ],
                                    if (_comments[index]['creator'] != _currentUsername) ...[
                                      PopupMenuButton(
                                        itemBuilder: (context) {
                                          return [
                                            const PopupMenuItem<int>(
                                              value: 1,
                                              child: Text("Report"),
                                            ),
                                          ];
                                        },
                                        onSelected: (value) {
                                          if(value == 1) {
                                            createReport(context, {"commentId": _comments[index]['commentId']});
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) => AlertDialog(
                                                title: const Text('Comment reported!'),
                                                content: const Text(
                                                    'This comment has been reported and will be reviewed by our moderators.'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context, 'Ok'),
                                                    child: const Text('Ok'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        }
                                      ),
                                    ],
                                  ]),
                            ),
                            const Divider(
                              height: 10,
                              thickness: 0.6,
                              indent: 0,
                              endIndent: 0,
                            ),
                            Row(
                              children: [
                                Text(
                                  _comments[index]['body'],
                                  style: const TextStyle(fontSize: 18),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        onRefresh: () async {
          setState(() {
            _isloading = true;
          });
          doGetPost();
        },
      ),
      bottomNavigationBar: const LinearNavBar(),
    );
  }
}
