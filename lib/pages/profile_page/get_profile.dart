import 'package:flutter/material.dart';
import 'package:linear/constants/themeSettings.dart';
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
  User _viewUser = User(username: '', name: '', communities: [], followers: [], following: []);
  cognito_user.User? currentUser = UserProvider().user;
  List<dynamic> _post = [];
  List<dynamic> _likedPosts = [];

  final ScrollController _scrollController = ScrollController();

  bool isLoading = true;
  bool isErrorFetchingUser = false;
  bool _isUpdatingFollow = false;

  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  isViewingOwnProfile() {
    return currentUser!.username == widget.username;
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

        print("_viewUser.followers is ${_viewUser.followers}");

        List<dynamic> post = (response['posts']);
        setState(() {
          _post = post;
          isLoading = false;
          _isFollowing = user.followers!.contains(currentUser!.username);
        });

        if (_post.isNotEmpty) {
          List<dynamic> likedPosts = [];
          for (var i = 0; i < _post.length; i++) {
            likedPosts.add(_post[i]['likes'].contains(user.username));
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

  @override
  Widget build(BuildContext context) {
    currentUser = Provider.of<UserProvider>(context).user;

    if (isLoading == false && isErrorFetchingUser == false) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 30.0),
              ),
              Text(
                "u/${_viewUser.username}",
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    UserIcon(radius: 50, username: _viewUser.username),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${_viewUser.followers?.length ?? 0}",
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const Text(
                            "Followers",
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${_viewUser.following?.length ?? 0}",
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const Text(
                            "Following",
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _viewUser.name,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
             if (!_isUpdatingFollow && !isViewingOwnProfile())
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                    _isUpdatingFollow = true;
                  });
                  await followAndUnfollow(widget.username, widget.token);
                  setState(() {
                    if (_isFollowing) {
                      _viewUser.followers!.remove(currentUser!.username);
                      _viewUser = _viewUser;
                    } else {
                       _viewUser.followers!.add(currentUser!.username);
                       _viewUser = _viewUser;
                    }
                    _isFollowing = !_isFollowing;
                    _isUpdatingFollow = false;
                  });
                  },
                  style: _isFollowing
                     ? AppThemes.secondaryTextButtonStyle(context)
                     : null,
                     child: Text(
                        _isFollowing ? "Unfollow" : "Follow"),
                ),
                if (_isUpdatingFollow && !isViewingOwnProfile())
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    child: const SizedBox(
                      height: 10.0,
                      width: 10.0,
                      child: CircularProgressIndicator(
                        valueColor:
                           AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                    ),
                  ),
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
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  // ignore: prefer_is_empty
                  if (_viewUser.communities?.length != 0) ...[
                    if ((_viewUser.communities?.length ?? 0) <= 3) ...[
                      CommunityListWidget(
                          user: _viewUser,
                          communityLength: _viewUser.communities?.length,
                          token: widget.token),
                    ] else ...[
                      CommunityListWidget(
                          user: _viewUser,
                          communityLength: 3,
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
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
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
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                              ),
                                                            )),
                                                        if (_viewUser.username ==
                                                            _viewUser.communities![
                                                                    index][1]
                                                                ['creator'])
                                                          Icon(
                                                            Icons
                                                                .admin_panel_settings,
                                                            color: AppThemes
                                                                .iconColor(
                                                                    context),
                                                            size: 30.0,
                                                          ),
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
                      fontWeight: FontWeight.w900,
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
                            ), onDelete: () { 
                              setState(() {
                                _post.removeAt(index);
                              });
                             },
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

