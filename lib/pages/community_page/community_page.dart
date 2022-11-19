import 'package:flutter/material.dart';
import 'package:linear/model/community.dart';
import 'package:linear/model/post.dart';
import 'package:linear/pages/common_widgets/navbar.dart';
import 'package:linear/pages/post_widgets/create_post.dart';
import 'package:linear/pages/goal_widgets/create_goal_widget.dart';
import 'package:linear/pages/post_widgets/post_widget.dart';
import 'package:linear/pages/goal_widgets/goal_widget.dart';
import 'package:linear/model/goal.dart';
import 'package:linear/util/apis.dart';
import 'package:linear/util/cognito/user.dart';
import 'package:linear/util/cognito/user_provider.dart';
import 'package:linear/util/date_formatter.dart';
import 'package:provider/provider.dart';
import 'package:linear/constants/themeSettings.dart';
import 'package:linear/util/cognito/auth_util.dart' as authUtil;
import 'package:intl/intl.dart';
import 'package:flutter/rendering.dart';

class CommunityPage extends StatefulWidget {
  CommunityPage({super.key, required this.communityName, required this.token});

  String communityName;
  String token;

  @override
  State<CommunityPage> createState() => CommunityPageState();
}

class CommunityPageState extends State<CommunityPage> {
  Community _community = Community(
      communityName: '',
      creationDate: 1,
      creator: '',
      members: [],
      checkIns: []);
  List<dynamic> _posts = [];

  User? user = UserProvider().user;
  //TODO: display finished goals somewhere on the page
  List<dynamic> _finishedGoals = [];
  dynamic _unfinishedGoal;

  bool _isUpdatingMembership = false;
  bool _isFetchingCommunity = false;
  bool _isErrorFetchingCommunity = false;
  final String _currentDate = DateFormat("MM/dd/yyyy").format(DateTime.now());

  bool _showActionButton = true;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()..addListener(scrollListener);
    authUtil.refreshTokenIfExpired().then(
          (response) => {
            if (response['refreshed'] == true)
              {
                Provider.of<UserProvider>(context, listen: false)
                    .setUser(response['user']),
              }
          },
        );

    doGetCommunity();
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    super.dispose();
  }

  scrollListener() {
    if (_showActionButton !=
        (scrollController.position.userScrollDirection ==
            ScrollDirection.forward)) {
      setState(() {
        _showActionButton = !_showActionButton;
      });
    }
  }

  doesCurrentDateExistInCheckins() {
    return _community.checkIns.isNotEmpty &&
            _community.checkIns[0]['date'] == _currentDate;
  }

  isUserCheckedIn() {
    return doesCurrentDateExistInCheckins() &&
            _community.checkIns[0]['usersCheckedIn'].contains(user!.username);
  }

  isMember() {
    return _community.members.contains(user!.username);
  }

  doGetCommunity({bool showLoadingIndicator = true}) {
    if(showLoadingIndicator){
      setState(() {
        _isFetchingCommunity = true;
      });
    }

    final Future<Map<String, dynamic>> responseMessage = getPostsForCommunity(widget.communityName, widget.token);

    responseMessage.then((response) {
      if (response['status'] == true) {
        setState(() {
          _community = Community.fromJson(response['community']);
          _posts = response['posts'];
          _finishedGoals = response['goals']["finishedGoals"];
          _unfinishedGoal = response['goals'] ["unfinishedGoal"];
        });

        setState(() {
          _isFetchingCommunity = false;
        });
      } else {
        setState(() {
          _isErrorFetchingCommunity = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).user;

    if (_isFetchingCommunity) {
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
    if (_isErrorFetchingCommunity) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Community"),
        ),
        body: const Center(
          child: Center(
            child: Text(
              "We ran into an error trying to obtain the community. \nPlease try again later.",
              textAlign: TextAlign.center,
            ),
          ),
        ),
        bottomNavigationBar: const LinearNavBar(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Community"),
      ),
      floatingActionButton: Visibility(
        visible: _showActionButton,
        child: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Actions'),
                content: SizedBox(
                  height: 90,
                  width: 50,
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ListTile(
                        title: const Text('Create Post'),
                        onTap: () {
                          Navigator.of(context).pop();
                          showDialog(
                              context: context,
                              builder: (context) {
                                return CreatePostWidget(
                                  communityName: widget.communityName,
                                  token: widget.token,
                                  onSuccess: () {
                                    Navigator.pop(context);
                                    doGetCommunity( showLoadingIndicator: false);
                                  },
                                );
                              });
                        },
                      ),
                      if(_unfinishedGoal == null && isMember())
                        ListTile(
                          title: const Text('Create Goal'),
                          onTap: () {
                            Navigator.of(context).pop();
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return CreateGoalWidget(
                                    communityName: widget.communityName,
                                    token: widget.token,
                                    onSuccess: (newGoal) {
                                      print("newGoal in community widget: ${newGoal.toString()}");
                                      setState(() {
                                        _unfinishedGoal = newGoal;
                                      });
                                      Navigator.pop(context);
                                    },
                                  );
                                });
                          },
                        ),
                    ],
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
          backgroundColor: AppThemes.primaryIconColor(context),
          child: const Icon(
            Icons.add_circle_outline,
            size: 57,
          ),
        ),
      ),
      body: RefreshIndicator(
        child: SingleChildScrollView(
          controller: scrollController,
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
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
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
                      if (doesCurrentDateExistInCheckins()) ...[
                        Text(
                          // ignore: unrelated_type_equality_checks
                          "${_community.checkIns[0]['usersCheckedIn'].length} check-ins today",
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
                            await joinAndLeave(
                                widget.communityName, widget.token);

                            setState(() {
                              if (isMember()) {
                                _community.members.remove(user!.username);
                                _community = _community;
                              } else {
                                _community.members.add(user!.username);
                                _community = _community;
                              }
                              _isUpdatingMembership = false;
                            });
                          },
                          style: isMember()
                              ? AppThemes.secondaryTextButtonStyle(context)
                              : null,
                          child: Text(
                              isMember() ? "Leave community" : "Join community"),
                        ),
                      if (_isUpdatingMembership)
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if(_unfinishedGoal != null)
                GoalWidget(
                  token: widget.token,
                  goal: Goal.fromJson( _unfinishedGoal),
                  onDelete: () {  
                    setState(() {
                      _unfinishedGoal = null;
                  });
                  }, 
                ),
              const SizedBox(height: 10),
              // ignore: prefer_is_empty
              if ((_posts.length) > 0) ...[
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _posts.length,
                    itemBuilder: (context, index) {
                      return PostWidget(
                        onLike: (likes) => setState(() {
                          _posts[index]['likes'] = likes;
                        }),
                        token: widget.token,
                        post: Post.fromJson(_posts[index]),
                        onDelete: () {
                          setState(() {
                            _posts.removeAt(index);
                          });
                        },
                        route: CommunityPage(
                          communityName: _community.communityName,
                          token: widget.token,
                        ),
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
          doGetCommunity();
        },
      ),
      bottomNavigationBar: const LinearNavBar(),
    );
  }
}
