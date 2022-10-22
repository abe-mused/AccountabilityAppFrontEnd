import 'package:flutter/material.dart';
import 'package:linear/model/user.dart';
import 'package:linear/model/post_list.dart';
import 'package:linear/constants/apis.dart';
import 'package:linear/pages/common_widgets/user_icon.dart';

// ignore: must_be_immutable
class GetProfileWidget extends StatefulWidget {
  GetProfileWidget({super.key, required this.token});
  String token;

  @override
  State<GetProfileWidget> createState() => _GetProfileWidgetState();
}

class _GetProfileWidgetState extends State<GetProfileWidget> {
  User _user = User(username: 'loading', name: 'loading', communities: [
    [
      {"communityName": "error"}
    ]
  ]);
  PostList _post = PostList(posts: []);

  var isLoading = true;
  var showAllCommunities = 0;
  var showAllPosts = 0;

  List colors = [Colors.grey, const Color.fromARGB(0, 0, 0, 0)];

  @override
  void initState() {
    super.initState();
    doGetUser();
  }

  doGetUser() {
    final Future<Map<String, dynamic>> successfulMessage =
        getProfile(widget.token);
    successfulMessage.then((response) {
      if (response['status'] == true) {
        User user = User.fromJson(response['user']);
        setState(() {
          _user = user;
        });
        print("it rain posts ${response['posts']}");
        PostList post = PostList.fromJson(response['posts']);
        setState(() {
          _post = post;
        });
        setState(() {
          isLoading = false;
        });
      } else {
        User user = User(username: 'error', name: 'error', communities: [
          [
            {"communityName": "error"}
          ]
        ]);
        setState(() {
          _user = user;
        });
        PostList post = PostList(posts: []);
        setState(() {
          _post = post;
        });
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error!"),
                content: const Text("No results found."),
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

  doShowAllCommunities() {
    if (showAllCommunities + 5 == _user.communities?.length) {
      setState(() {
        showAllCommunities = 0;
      });
    } else {
      setState(() {
        showAllCommunities = (_user.communities?.length ?? 0) - 5;
      });
    }
  }

  doShowAllPosts() {
    if (showAllPosts + 5 == _post.posts.length) {
      setState(() {
        showAllPosts = 0;
      });
    } else {
      setState(() {
        showAllPosts = (_post.posts.length - 5);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading == false) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        // ignore: unnecessary_string_interpolations
                        "${_user.name}",
                        style: const TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      //add logOut button here: dropDown menu with logOut option
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.more_horiz,
                          size: 30.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              UserIcon(radius: 100, username: _user.username),
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
              ),
              Text(
                "@${_user.username}",
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 30.0,
                ),
              ),
              const SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(width: 20.0),
                  Column(
                    children: [
                      const Text(
                        "29",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      Text(
                        "Following",
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.3),
                            fontSize: 20.0,
                            fontWeight: FontWeight.w100),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      //turn into button - owner should be able to see followers
                      const Text(
                        "121.9k",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      //turn into button - owner and others should be able to see following
                      const SizedBox(height: 5.0),
                      Text(
                        "Followers",
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.3),
                            fontSize: 20.0,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20.0),
                ],
              ),
              const SizedBox(height: 30.0),
              // add logic, if user viewing is not the same as the user displayed, then show follow button
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     ElevatedButton(
              //       onPressed: () {},
              //       style: ElevatedButton.styleFrom(
              //         fixedSize: const Size(140.0, 55.0),
              //         primary: Colors.green,
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(15.0),
              //         ),
              //       ),
              //       child: const Text(
              //         "Follow",
              //         style: TextStyle(fontSize: 18.0),
              //       ),
              //     ),

              //   ],
              // ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  SizedBox(width: 15.0),
                  Text(
                    "Communities",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 23.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  // ignore: prefer_is_empty
                  if (_user.communities?.length != 0) ...[
                    if ((_user.communities?.length ?? 0) < 5) ...[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 5.0),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _user.communities?.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              tileColor: colors[index % colors.length],
                              title: Text(_user.communities![index][0]
                                  ['communityName']),
                            );
                          },
                        ),
                      ),
                    ] else ...[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 5.0),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 5 + showAllCommunities,
                          itemBuilder: (context, index) {
                            return ListTile(
                              tileColor: colors[index % colors.length],
                              title: Text(_user.communities![index][0]
                                  ['communityName']),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: TextButton(
                              onPressed: () {
                                doShowAllCommunities();
                              },
                              child: Text(
                                showAllCommunities == 0
                                    ? "Show More"
                                    : "Show Less",
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5.0),
                        ],
                      ),
                    ],
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return ListTile(
                            tileColor: colors[index % colors.length],
                            title: const Text(
                                'You are not part of a community, try joining one!'),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  SizedBox(width: 15.0),
                  Text(
                    "Posts",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 23.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              //Posts list builder
              Column(
                children: [
                  // ignore: prefer_is_empty
                  if (_post.posts.length != 0) ...[
                    if ((_post.posts.length) < 5) ...[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 5.0),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _post.posts.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              tileColor: colors[index % colors.length],
                              title: Text(_post.posts[index]['title']),
                            );
                          },
                        ),
                      ),
                    ] else ...[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 5.0),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 5 + showAllPosts,
                          itemBuilder: (context, index) {
                            return ListTile(
                              tileColor: colors[index % colors.length],
                              title: Text(_post.posts[index]['title']),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: TextButton(
                              onPressed: () {
                                doShowAllPosts();
                              },
                              child: Text(
                                showAllPosts == 0
                                    ? "Show More"
                                    : "Show Less",
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5.0),
                        ],
                      ),
                    ],
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return ListTile(
                            tileColor: colors[index % colors.length],
                            title: const Text(
                                'You haven\'t made a post, try making one first!'),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 80.0),
            ],
          ),
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
