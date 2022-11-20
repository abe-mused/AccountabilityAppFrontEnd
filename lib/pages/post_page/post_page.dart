import 'package:flutter/material.dart';
import 'package:linear/model/post.dart';
import 'package:linear/pages/common_widgets/navbar.dart';
import 'package:linear/pages/post_page/create_comment_widget.dart';
import 'package:linear/pages/post_widgets/post_widget.dart';
import 'package:linear/pages/profile_page/profile_page.dart';
import 'package:linear/util/apis.dart';
import 'package:linear/util/cognito/user.dart';
import 'package:linear/util/cognito/user_provider.dart';
import 'package:linear/util/date_formatter.dart';
import 'package:provider/provider.dart';
import 'package:linear/pages/common_widgets/user_icon.dart';

class PostPage extends StatefulWidget {
  PostPage(
      {super.key,
      required this.postId,
      required this.token,
      required this.route});

  String postId;
  String token;
  Widget route;

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
      comments: []);
  List<dynamic> _comments = [];

  User? user = UserProvider().user;

  bool _isloading = true;

  @override
  void initState() {
    super.initState();
    doGetPost();
  }

  deletePost(context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => widget.route));
  }

  doDeleteComment(passIndex) {
    final Future<Map<String, dynamic>> responseMessage = 
        deleteComment(context, widget.postId, _comments[passIndex]['commentId']);
    responseMessage.then((response) {
      if (response['status'] == true) {
        setState(() {
          _comments.removeAt(passIndex);
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
    user = Provider.of<UserProvider>(context).user;
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
                  token: widget.token,
                  post: _post,
                  onDelete: () {
                    deletePost(context);
                  },
                  route: widget.route,
                ),
              ),
              const SizedBox(height: 10),
              CreateCommentWidget(
                token: widget.token,
                postId: widget.postId,
                addComment: (comment) => {
                  setState(() {
                    _comments.add(comment);
                  }),
                },
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
                                                username: _comments[index]
                                                    ['creator'],
                                              ),
                                            ),
                                          );
                                        },
                                        child: UserIcon(
                                          username: _comments[index]['creator'],
                                          radius: 45,
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
                                    if (_comments[index]['creator'] == user!.username) ...[
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
                                    if (_comments[index]['creator'] != user!.username) ...[
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
