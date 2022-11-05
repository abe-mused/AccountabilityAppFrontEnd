import 'package:flutter/material.dart';
import 'package:linear/model/post.dart';
import 'package:linear/pages/post_page/post_page.dart';
import 'package:linear/util/date_formatter.dart';
import 'package:linear/pages/common_widgets/user_icon.dart';
import 'package:linear/pages/profile_page/profile_page.dart';
import 'package:linear/util/apis.dart';
import 'package:linear/constants/themeSettings.dart';

class PostWidget extends StatelessWidget {
  const PostWidget(
      {super.key,
      required this.post,
      required this.liked,
      required this.onLike,
      required this.token});
  final Post post;
  final String token;
  final bool liked;
  final VoidCallback onLike;

  likeUnlikePost() {
    final Future<Map<String, dynamic>> successfulMessage =
        likePost(post.postId, token);
    successfulMessage.then((response) {
      if (response['status'] == true) {
        onLike();
      } else {}
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
                                username: post.creator,
                              ),
                            ),
                          );
                        },
                        child: UserIcon(
                          username: post.creator,
                          radius: 45,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "c/${post.communityName}",
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            "u/${post.creator}",
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            getFormattedDate(post.creationDate),
                            style: const TextStyle(fontSize: 12),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
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
                                  deletePost(post.postId, token);
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
                                  post.title,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 5),
                                if (post.body.length > 300) ...[
                                  SizedBox(
                                    height: 200,
                                    child: Scrollbar(
                                      thumbVisibility: true,
                                      controller: scrollController,
                                      child: Material(
                                        child: SingleChildScrollView(
                                          controller: scrollController,
                                          child: Text(
                                            post.body,
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
                                    post.body,
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
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostPage(
                                    postId: post.postId,
                                    token: token,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.comment,
                              size: 34.0,
                            ),
                          ),
                          if (liked) ...[
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
