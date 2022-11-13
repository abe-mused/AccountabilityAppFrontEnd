import 'package:flutter/material.dart';
import 'package:linear/model/post.dart';
import 'package:linear/pages/post_page/post_page.dart';
import 'package:linear/util/date_formatter.dart';
import 'package:linear/pages/common_widgets/user_icon.dart';
import 'package:linear/pages/profile_page/profile_page.dart';
import 'package:linear/util/apis.dart';
import 'package:linear/util/cognito/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:linear/util/cognito/user.dart' as cognito_user;

class PostWidget extends StatefulWidget {
  const PostWidget(
      {super.key,
      required this.post,
      required this.liked,
      required this.onLike,
      required this.token,
      required this.onDelete,
      required this.route});
  final Post post;
  final String token;
  final bool liked;
  final VoidCallback onLike;
  final VoidCallback onDelete;
  final Widget route;

  @override
  State<StatefulWidget> createState() => _PostWidget();
}

class _PostWidget extends State<PostWidget> {
  cognito_user.User? user = UserProvider().user;

  isNewRoute(context) {
    var route = ModalRoute.of(context);

    final newRoute = MaterialPageRoute(
      builder: (context) => PostPage(
        postId: widget.post.postId,
        token: widget.token,
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
    final Future<Map<String, dynamic>> responseMessage =
        likePost(widget.post.postId, widget.token);
    responseMessage.then((response) {
      if (response['status'] == true) {
        widget.onLike();
      } else {}
    });
  }

  doDeletePost() {
    final Future<Map<String, dynamic>> responseMessage =
        deletePost(widget.post.postId, widget.token);
    responseMessage.then((response) {
      if (response['status'] == true) {
        widget.onDelete();
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).user;

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
                                  username: widget.post.creator,
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
                          Text(
                            "c/${widget.post.communityName}",
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            "u/${widget.post.creator}",
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            getFormattedDate(widget.post.creationDate),
                            style: const TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    if (widget.post.creator == user!.username) ...[
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
                    if(widget.post.imageUrl != null) ...[
                      const SizedBox(height: 10),
                      Image.network(widget.post.imageUrl!, height: 200),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (isNewRoute(context))
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostPage(
                                    postId: widget.post.postId,
                                    token: widget.token,
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
                        if (widget.liked) ...[
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
