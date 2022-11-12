import 'package:flutter/material.dart';
import 'package:linear/model/community.dart';
import 'package:linear/model/post.dart';
import 'package:linear/pages/common_widgets/navbar.dart';
import 'package:linear/pages/post_widgets/create_post.dart';
import 'package:linear/pages/goal_widgets/create_goal_widget.dart';
import 'package:linear/pages/post_widgets/post_widget.dart';
import 'package:linear/util/apis.dart';
import 'package:linear/util/cognito/user.dart';
import 'package:linear/util/cognito/user_provider.dart';
import 'package:linear/util/date_formatter.dart';
import 'package:provider/provider.dart';
import 'package:linear/constants/themeSettings.dart';
import 'package:linear/util/cognito/auth_util.dart' as authUtil;
import 'package:intl/intl.dart';

class CommunityPage extends StatefulWidget {
  CommunityPage({super.key, required this.communityName, required this.token});

  String communityName;
  String token;

  @override
  State<CommunityPage> createState() => CommunityPageState();
}

class CommunityPageState extends State<CommunityPage> {
  Community _community = Community(communityName: '', creationDate: 1, creator: '', members: [], checkIns: []);
  List<dynamic> _posts = [];

  User? user = UserProvider().user;
  List<dynamic> _likedPosts = [];
  bool _isMember = false;

  bool _isUpdatingMembership = false;
  bool _isloading = true;
  final String _currentDate = DateFormat("dd/MM/yyyy").format(DateTime.now());
  bool _currentDateExists = false;
  bool _currentUserCheckedIn = false;

  @override
  void initState() {
    super.initState();

    authUtil.refreshTokenIfExpired().then((response) => {
          if (response['refreshed'] == true)
            {
              Provider.of<UserProvider>(context, listen: false).setUser(response['user']),
            }
        },
      );

    doGetCommunity();
  }

  updateCommunity(Post newPost) {
    //update check in
    if (_isMember && !_currentUserCheckedIn) {
      if (_currentDateExists) {
        setState(() {
          _community.checkIns[0][1]['usersCheckedIn']
              .add(user!.username.toString());
          _community = _community;
          _currentUserCheckedIn = true;
        });
      } else {
        setState(() {
          _community.checkIns.insert(0, [
            {"date": _currentDate.toString()},
            {
              "usersCheckedIn": [user!.username.toString()]
            }
          ]);
          _community = _community;
          _currentDateExists = true;
          _currentUserCheckedIn = true;
        });
      }
    }

    //update postList
    setState(() {
      _posts.add({
        'postId': newPost.postId,
        'title': newPost.title,
        'body': newPost.body,
        'creator': user!.username,
        'creationDate': newPost.creationDate.toString(),
        'community': widget.communityName,
        'likes': [],
        'comments': [],
      });
      _likedPosts.add(false);
      _posts = _posts;
      _likedPosts = _likedPosts;
    });
  }

  doGetCommunity() {
    final Future<Map<String, dynamic>> successfulMessage = getPostsForCommunity(widget.communityName, widget.token);
    successfulMessage.then((response) {
      if (response['status'] == true) {
        Community community = Community.fromJson(response['community']);

        setState(() {
          _community = community;
        });

        List<dynamic> post = (response['posts']);
        setState(() {
          _posts = post;
        });
        if (_community.checkIns.isNotEmpty &&
            _community.checkIns[0][0]['date'] == _currentDate) {
          setState(() {
            _currentDateExists = true;
          });
          if (_community.checkIns[0][1]['usersCheckedIn']
              .contains(user!.username)) {
            setState(() {
              _currentUserCheckedIn = true;
            });
          }
        }

        if (_posts.isNotEmpty) {
          List<dynamic> likedPosts = [];
          for (var i = 0; i < _posts.length; i++) {
            likedPosts.add(_posts[i]['likes'].contains(user!.username));
          }
          setState(() {
            _likedPosts = likedPosts;
          });
        }
        setState(() {
          _isMember = _community.members.contains(user!.username);
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
          title: const Text("Community"),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
        bottomNavigationBar: const LinearNavBar(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Community"),
      ),
      body: RefreshIndicator(
        child: SingleChildScrollView(
          // removes bottom overflow pixel error
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  margin: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "c/${_community.communityName}",
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Created on ${getFormattedDate(_community.creationDate)}",
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        // ignore: unrelated_type_equality_checks
                        "${_community.members.length} members",
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      if (_currentDateExists) ...[
                        Text(
                          // ignore: unrelated_type_equality_checks
                          "${_community.checkIns[0][1]['usersCheckedIn'].length} check-ins today",
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ] else ...[
                        const Text(
                          "0 check-ins today",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: 10),
                      if (!_isUpdatingMembership)
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _isUpdatingMembership = true;
                            });
                            await joinAndLeave(widget.communityName, widget.token);

                            setState(() {
                              if (_isMember) {
                                _community.members.remove(user!.username);
                                _community = _community;
                              } else {
                                _community.members.add(user!.username);
                                _community = _community;
                              }
                              _isMember = !_isMember;
                              _isUpdatingMembership = false;
                            });
                          },
                          style: _isMember ? AppThemes.secondaryTextButtonStyle(context) : null,
                          child: Text(_isMember ? "Leave community" : "Join community"),
                        ),
                      if (_isUpdatingMembership)
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
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              CreateGoalWidget(token: widget.token, communityName: widget.communityName),
              const SizedBox(height: 10),
              CreatePostWidget(token: widget.token, communityName: widget.communityName, onSuccess: (newPost) => updateCommunity(newPost),),
              const SizedBox(height: 10),
              // ignore: prefer_is_empty
              if ((_posts.length) > 0) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _posts.length,
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
                          communityName: _posts[index]['community'],
                          postId: _posts[index]['postId'],
                          creator: _posts[index]['creator'],
                          creationDate: int.parse(_posts[index]['creationDate']),
                          title: _posts[index]['title'],
                          body: _posts[index]['body'],
                          likes: _posts[index]['likes'],
                        ),
                        onDelete: () {
                        setState(() {
                           _posts.removeAt(index);
                              });
                        },
                      );
                    },
                  ),
                ),
              ] else ...[
                const Center(
                  child: Text("No posts yet"),
                ),
              ],
            ],
          ),
        ),
        onRefresh: () async {
          setState(() {
            _isloading = true;
          });
          doGetCommunity();
        },
      ),
      bottomNavigationBar: const LinearNavBar(),
    );
  }
}
