import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:linear/model/post.dart';
import 'package:linear/pages/community_page.dart';
import 'package:linear/pages/post_page/post_page.dart';
import 'package:linear/util/date_formatter.dart';
import 'package:linear/pages/common_widgets/user_icon.dart';
import 'package:linear/pages/profile_page/profile_page.dart';
import 'package:linear/util/apis.dart';
import 'package:linear/util/cognito/auth_util.dart' as auth_util;


class PostWidget extends StatefulWidget {
  PostWidget(
      {super.key,
      required this.post,
      required this.onLike,
      required this.onDelete,
      required this.route,
      this.isPostPage = false});
  final Post post;
  final Function onLike;
  final VoidCallback onDelete;
  final Widget route;
  bool isPostPage;

  @override
  State<StatefulWidget> createState() => _PostWidget();
}

class _PostWidget extends State<PostWidget> {

  String? _currentUsername;

  isNewRoute(context) {
    var route = ModalRoute.of(context);

    final newRoute = MaterialPageRoute(
      builder: (context) => PostPage(
        postId: widget.post.postId,
        route: widget.route, 
      ),
    );
    if (route != null) {
      return route.settings != newRoute.settings;
    } else {
      return false;
    }
  }

  likeUnlikePost() {
    if (widget.post.likes!.contains(_currentUsername)) {
      widget.post.likes!.remove(_currentUsername);
    } else {
      widget.post.likes!.add(_currentUsername);
    }
    widget.onLike(widget.post.likes);
    final Future<Map<String, dynamic>> responseMessage = likePost(context, widget.post.postId);
    responseMessage.then((response) {
      if (response['status'] == true) {
      } else {
        if (widget.post.likes!.contains(_currentUsername)) {
          widget.post.likes!.remove(_currentUsername);
        } else {
          widget.post.likes!.add(_currentUsername);
        }
        widget.onLike(widget.post.likes);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error!"),
                content: const Text(
                    "An error occured while attempting to like the post."),
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

  doDeletePost() {
    final Future<Map<String, dynamic>> responseMessage =
        deletePost(context, widget.post.postId);
    responseMessage.then((response) {
      if (response['status'] == true) {
        widget.onDelete();
      } else {
         const AlertDialog(
          title: Text("Error!"),
          content: Text('An error occurred while deleting the post, please try again.'),
        );
      }
    });
  }

  @override
    void initState() {
      super.initState();
      
      auth_util.getUserName().then((userName) {
        setState(() {
          _currentUsername = userName;
        });
      });
    }
    
  @override
  Widget build(BuildContext context) {

    final ScrollController scrollController = ScrollController();
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
                                  usernameToDisplay: widget.post.creator,
                                ),
                              ),
                            );
                          },
                          child: UserIcon(
                            username: widget.post.creator,
                            radius: 45,
                          ),
                        )),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                              TextSpan(
                                  text: 'c/${widget.post.communityName}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CommunityPage(
                                            communityName: widget.post.communityName,
                                          ),
                                        ),
                                      );
                                    }
                                ),
                              ]
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                              TextSpan(
                                  text: 'u/${widget.post.creator}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProfilePage(
                                            usernameToDisplay: widget.post.creator,
                                          ),
                                        ),
                                      );
                                    }
                                ),
                              ]
                            ),
                          ),
                          Text(
                            getFormattedDate(widget.post.creationDate),
                            style: const TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    if (widget.post.creator == _currentUsername) ...[
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
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    doDeletePost();
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Yes'),
                                ),
                              ],
                            ),
                          );
                        }
                      }),
                    ],
                    if (widget.post.creator != _currentUsername) ...[
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
                            createReport(context, {"postId": widget.post.postId});
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Post reported!'),
                                content: const Text(
                                    'This post has been reported and will be reviewed by our moderators.'),
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
                    ]
                  ],
                ),
              ),
              const Divider(
                height: 10,
                thickness: 0.6,
                indent: 0,
                endIndent: 0,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.post.title,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 5),
                                if (widget.post.body.length > 300) ...[
                                  SizedBox(
                                    height: 200,
                                    child: Scrollbar(
                                      thumbVisibility: true,
                                      controller: scrollController,
                                      child: Material(
                                        child: SingleChildScrollView(
                                          controller: scrollController,
                                          child: Text(
                                            widget.post.body,
                                            style:
                                                const TextStyle(fontSize: 16),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ] else ...[
                                  Text(
                                    widget.post.body,
                                    style: const TextStyle(fontSize: 16),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 1000,
                    ),
                    if (widget.post.imageUrl != null) ...[
                      const SizedBox(height: 10),
                      Image.network(widget.post.imageUrl!, height: 200),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (!widget.isPostPage)
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostPage(
                                    postId: widget.post.postId,
                                    route: widget.route, 
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.comment,
                              size: 34.0,
                            ),
                          ),
                        if (widget.post.likes!.contains(_currentUsername)) ...[
                          IconButton(
                            onPressed: () {
                              likeUnlikePost();
                            },
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.pink,
                              size: 34.0,
                            ),
                          )
                        ] else ...[
                          IconButton(
                            onPressed: () {
                              likeUnlikePost();
                            },
                            icon: const Icon(
                              Icons.favorite_border,
                              size: 34.0,
                            ),
                          )
                        ]
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
