import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:linear/model/user.dart';
import 'package:linear/util/apis.dart';
import 'package:linear/pages/common_widgets/user_icon.dart';
import 'package:linear/pages/community_page/community_page.dart';
import 'package:linear/pages/post_widgets/post_widget.dart';
import 'package:linear/model/post.dart';
import 'package:linear/pages/profile_page/community_list.dart';
import 'package:linear/util/cognito/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:linear/util/cognito/user.dart' as cognito_user;

// ignore: must_be_immutable
class GetProfileWidget extends StatefulWidget {
  const GetProfileWidget(
      {super.key, required this.token, required this.username});
  final String token;
  final String username;

  @override
  State<GetProfileWidget> createState() => _GetProfileWidgetState();
}

class _GetProfileWidgetState extends State<GetProfileWidget> {
  User _viewUser = User(username: '', name: '', communities: []);
  cognito_user.User? user = UserProvider().user;
  List<dynamic> _post = [];
  List<dynamic> _likedPosts = [];
  String followButtonText = " ";
  String secondaryFollowButtonText = " ";

  final ScrollController _scrollController = ScrollController();

  bool isLoading = true;
  bool isErrorFetchingUser = false;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() {
    final Future<Map<String, dynamic>> successfulMessage =
        getProfile(widget.username, widget.token);
    successfulMessage.then((response) {
      if (response['status'] == true) {
        User user = User.fromJson(response['user']);
        setState(() {
          _viewUser = user;
        });

        List<dynamic> post = (response['posts']);
        setState(() {
          _post = post;
        });
        setState(() {
          isLoading = false;
        });

        if (_post.isNotEmpty) {
          List<dynamic> likedPosts = [];
          for (var i = 0; i < _post.length; i++) {
            likedPosts.add(_post[i]['likes'].contains(user.username));
            print(likedPosts[i]);
          }
          setState(() {
            _likedPosts = likedPosts;
          });
        }
      } else {
        setState(() {
          isLoading = false;
          isErrorFetchingUser = true;
        });
      }
    });
  }

    statusFollow(){
    var isFollowing = 0;
    
    if(_viewUser.followers!=null){
      for (var i = 0; i < _viewUser.followers!.length; i++) {
          if(_viewUser.followers![i].contains(user!.username)){
          followButtonText = "Following";
          secondaryFollowButtonText = "Follow";
          isFollowing = 1; 
        }
      }
    }
    if(isFollowing != 1){
    followButtonText = "Follow";
    secondaryFollowButtonText = "Following";
    }
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).user;
    statusFollow();

    if (isLoading == false && isErrorFetchingUser == false) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 30.0),
              ),
              UserIcon(radius: 100, username: _viewUser.username),
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
              ),
              Text(
                // ignore: unnecessary_string_interpolations
                "${_viewUser.name}",
                style: const TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
              ElevatedButton(
                      onPressed: () {
                        followAndUnfollow(widget.username, widget.token);
                        setState(() {
                         followButtonText = secondaryFollowButtonText;
                       });
                       },
                       child: Text(followButtonText)
                     ),
              Text(
                "@${_viewUser.username}",
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 22.0,
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 5.0, bottom: 15.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      //add logOut button here: dropDown menu with logOut option
                      Text(
                        "${_viewUser.followers?.length ?? 0} Followers",
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 22.0,
                        ),
                      ),
                      Text(
                        "${_viewUser.following?.length ?? 0} Following",
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 22.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
                  if (_viewUser.communities?.length != 0) ...[
                    if ((_viewUser.communities?.length ?? 0) < 5) ...[
                      CommunityListWidget(
                          user: _viewUser,
                          communityLength: _viewUser.communities?.length,
                          token: widget.token),
                    ] else ...[
                      CommunityListWidget(
                          user: _viewUser,
                          communityLength: 5,
                          token: widget.token),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('All Communities'),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    content: SizedBox(
                                      height: 300,
                                      width: 300,
                                      child: Scrollbar(
                                        thumbVisibility: true,
                                        controller: _scrollController,
                                        child: ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          controller: _scrollController,
                                          shrinkWrap: true,
                                          itemCount:
                                              _viewUser.communities?.length,
                                          itemBuilder: (context, index) {
                                            return Material(
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9,
                                                child: Card(
                                                  margin: const EdgeInsets.only(
                                                      top: 10.0,
                                                      left: 5.0,
                                                      right: 5.0),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Column(
                                                      children: <Widget>[
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          CommunityPage(
                                                                    communityName:
                                                                        _viewUser.communities![index][0]
                                                                            [
                                                                            'communityName'],
                                                                    token: widget
                                                                        .token,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: Text(
                                                              "c/${_viewUser.communities![index][0]['communityName']}",
                                                              style: const TextStyle(
                                                                  fontFamily:
                                                                      'MonteSerrat',
                                                                  fontSize: 16),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Okay'))
                                    ],
                                  ),
                                );
                              },
                              child: const Text(
                                "Show More",
                                style: TextStyle(
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
                        child: Text(
                            '${_viewUser.username} is not part of a community!')),
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
                  if (_post.length != 0) ...[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 5.0),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _post.length,
                        itemBuilder: (context, index) {
                          return PostWidget(
                            liked: _likedPosts[index],
                            onLike: () {
                              setState(() {
                                _likedPosts[index] = !_likedPosts[index];
                              });
                            },
                            token: widget.token,
                            post: Post(
                              communityName: _post[index]['community'],
                              postId: _post[index]['postId'],
                              creator: _post[index]['creator'],
                              creationDate:
                                  int.parse(_post[index]['creationDate']),
                              title: _post[index]['title'],
                              body: _post[index]['body'],
                              likes: _post[index]['likes'],
                            ),
                          );
                        },
                      ),
                    ),
                  ] else ...[
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
                        child: Text('${_viewUser.name} hasn\'t made a post!')),
                  ],
                ],
              ),
              const SizedBox(height: 80.0),
            ],
          ),
        ),
      );
    } else if (isLoading == false && isErrorFetchingUser == true) {
      return const Scaffold(
        body: Center(
          child: Text(
            "We ran into an error trying to obtain the profile. \nPlease try again later.",
            textAlign: TextAlign.center,
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
