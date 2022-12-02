// ignore_for_file: must_be_immutable

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:linear/constants/themeSettings.dart';
import 'package:linear/model/post.dart';
import 'package:linear/pages/community_page/community_page.dart';
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
    final Future<Map<String, dynamic>> responseMessage = deletePost(context, widget.post.postId);
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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(bottom: 5),
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
                        child: widget.post.creatorProfileImageUrl == null?
                            UserIcon(radius: 45, username:widget.post.creator)
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(45),
                                child: SizedBox.fromSize(
                                  size: const Size.fromRadius(45),
                                  child: Image.network(widget.post.creatorProfileImageUrl!, fit: BoxFit.cover),
                                ),
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
                                style: TextStyle(
                                  color: MediaQuery.of(context).platformBrightness == Brightness.dark
                                    ? AppThemes.darkTheme.primaryColor
                                    : AppThemes.lightTheme.primaryColor,
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
                                style: TextStyle(
                                  color: MediaQuery.of(context).platformBrightness == Brightness.dark
                                    ? AppThemes.darkTheme.primaryColor
                                    : AppThemes.lightTheme.primaryColor,
                                  fontSize: 24,
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
                                  },
                              ),
                            ],
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
                      },
                    ),
                  ],
                ],
              ),
            ),
            const Divider(
              height: 10,
              thickness: 0.6,
              indent: 0,
              endIndent: 0,
            ),
            Container(
              padding: const EdgeInsets.only(top: 5),
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
                                textAlign: TextAlign.left,
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
                  if (widget.post.imageUrl != null) ...[
                    const SizedBox(height: 10),
                    FullScreenWidget(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          widget.post.imageUrl!,
                          height: 300
                          ),
                      ),
                    )
                  ],
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    height: 10,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${widget.post.commentCount} ",
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "comment${widget.post.commentCount > 1 ? "s" : ""}",
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (!widget.isPostPage) ...[
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
                          ],
                          const SizedBox(
                            width: 10,
                          ),
                          ConstrainedBox(
                              constraints: BoxConstraints(
                                //This is just so the like icon doesn't move when the user likes/unlikes the post
                                minWidth: widget.post.likes!.length < 9? 65 : 70,
                              ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    likeUnlikePost();
                                  },
                                  icon: Icon(
                                    Icons.favorite,
                                    color: (widget.post.likes!.contains(_currentUsername))? Colors.pink : null,
                                    size: 34.0,
                                  ),
                                ),
                                Text(
                                  widget.post.likes!.length.toString(),
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ]
                            ),
                          ),
                        ],
                      ),
                    ]
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
