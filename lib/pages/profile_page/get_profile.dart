import 'package:flutter/material.dart';
import 'package:linear/constants/themeSettings.dart';
import 'package:linear/model/user.dart';
import 'package:linear/pages/profile_page/profile_page.dart';
import 'package:linear/util/apis.dart';
import 'package:linear/pages/common_widgets/user_icon.dart';
import 'package:linear/pages/community_page/community_page.dart';
import 'package:linear/pages/common_widgets/post_widget.dart';
import 'package:linear/model/post.dart';
import 'package:linear/pages/profile_page/community_list.dart';
import 'package:linear/pages/profile_page/follows_page/view_follows.dart';
import 'package:linear/util/date_formatter.dart';
import 'package:linear/util/cognito/auth_util.dart' as auth_util;

// ignore: must_be_immutable
class GetProfileWidget extends StatefulWidget {
  const GetProfileWidget(
      {super.key, required this.username});
  final String username;

  @override
  State<GetProfileWidget> createState() => _GetProfileWidgetState();
}

class _GetProfileWidgetState extends State<GetProfileWidget> {
  User _viewUser = User(username: '', name: '', communities: [], followers: [], following: []);

  String? _currentUsername;
  List<dynamic> _post = [];

  final ScrollController _scrollController = ScrollController();

  bool isLoading = true;
  bool isErrorFetchingUser = false;
  bool _isUpdatingFollow = false;

  bool _isFollowing = false;
  int currentEpoch = DateTime.now().millisecondsSinceEpoch;

  List _streak = [];

  calculateStreak(index) {
    _streak.add(computeStreak(
        _viewUser.communities![index]['firstStreakDate'],
        _viewUser.communities![index]['lastStreakDate'],
        currentEpoch));
    return _streak[index];
  }

  @override
  void initState() {
    super.initState();
    
    auth_util.getUserName().then((userName) {
      setState(() {
        _currentUsername = userName;
      });
    });

    getUser();
  }

  isViewingOwnProfile() {
    return _currentUsername == widget.username;
  }

  getUser() {
    final Future<Map<String, dynamic>> successfulMessage =
        getProfile(context, widget.username);
    successfulMessage.then((response) {
      if (response['status'] == true) {
        User user = User.fromJson(response['user']);

        if(user.imageUrl != null){
          print("user.imageUrl ${user.imageUrl}");
        }
        
        setState(() {
          _viewUser = user;
        });

        List<dynamic> post = (response['posts']);
        setState(() {
          _post = post;
          isLoading = false;
          _isFollowing = user.followers!.contains(_currentUsername);
        });

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

    buildFollowButton(){
      if (!_isUpdatingFollow && !isViewingOwnProfile()){
       return ElevatedButton(
          onPressed: () async {
            setState(() {
              _isUpdatingFollow = true;
            });
            await followAndUnfollow(context, widget.username);
            setState(() {
              if (_isFollowing) {
                _viewUser.followers!.remove(_currentUsername);
                _viewUser = _viewUser;
              } else {
                _viewUser.followers!.add(_currentUsername);
                _viewUser = _viewUser;
              }
              _isFollowing = !_isFollowing;
              _isUpdatingFollow = false;
            });
          },
          style: _isFollowing
              ? AppThemes.secondaryTextButtonStyle(context)
              : null,
          child: Text(_isFollowing ? "Unfollow" : "Follow"),
        );
      } else if (_isUpdatingFollow && !isViewingOwnProfile()) {
        return ElevatedButton(
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
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        );
      } else {
        return Container();
      }
    }

    if (isLoading == false && isErrorFetchingUser == false) {
      return Scaffold(
        body: RefreshIndicator(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 30.0),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      if(_viewUser.imageUrl != null) ...[
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: Image.network(_viewUser.imageUrl ?? "").image,
                            fit: BoxFit.fill
                          ),
                          ),
                        )
                      ] else ...[
                        UserIcon(radius: 50, username: _viewUser.username),
                      ],
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewFollowsPage(
                                          username: _viewUser.username,
                                          user: _viewUser,
                                          type: "followers"),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      "${_viewUser.followers?.length ?? 0}",
                                      style: const TextStyle(
                                          fontSize: 24, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    const Text(
                                        "Followers",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                  ]
                                ), 
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewFollowsPage(
                                          username: _viewUser.username,
                                          user: _viewUser,
                                          type: "following"),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      "${_viewUser.following?.length ?? 0}",
                                      style: const TextStyle(
                                          fontSize: 24, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    const Text(
                                      "Following",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ]
                                ), 
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              buildFollowButton(),
                            ]
                          ),
                        ],
                      )
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
                          fontSize: 22.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "u/${_viewUser.username}",
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
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
                          currentEpoch: currentEpoch,
                        ),
                      ] else ...[
                        CommunityListWidget(
                          user: _viewUser,
                          communityLength: 3,
                          currentEpoch: currentEpoch,
                        ),
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
                                        borderRadius:
                                            BorderRadius.circular(15.0),
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
                                                    margin:
                                                        const EdgeInsets.only(
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
                                                                          _viewUser.communities![index]['communityName'],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              child: Text(
                                                                "c/${_viewUser.communities![index]['communityName']}",
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                ),
                                                              )),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              if (calculateStreak(
                                                                      index) >=
                                                                  3) ...[
                                                                Text(
                                                                  "${_streak[index]}",
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        16.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                  ),
                                                                ),
                                                                Icon(
                                                                  Icons
                                                                      .local_fire_department,
                                                                  color: AppThemes
                                                                      .iconColor(
                                                                          context),
                                                                  size: 30.0,
                                                                ),
                                                              ],
                                                              if (_viewUser.username == _viewUser.communities![index]['creator']) 
                                                                  ...[
                                                                Icon(
                                                                  Icons
                                                                      .admin_panel_settings,
                                                                  color: AppThemes
                                                                      .iconColor(
                                                                          context),
                                                                  size: 30.0,
                                                                ),
                                                              ],
                                                            ],
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
                              onLike: (likes) => setState(() {
                                _post[index]['likes'] = likes;
                              }),
                              post: Post.fromJson(_post[index]),
                              onDelete: () {
                                setState(() {
                                  _post.removeAt(index);
                                });
                              },
                              route: const ProfilePage(),
                            );
                          },
                        ),
                      ),
                    ] else ...[
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
                          child:
                              Text('${_viewUser.name} hasn\'t made a post!')),
                    ],
                  ],
                ),
                const SizedBox(height: 80.0),
              ],
            ),
          ),
          onRefresh: () async {
            setState(() {
              isLoading = true;
            });
            await getUser();
          },
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
